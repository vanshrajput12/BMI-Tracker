// pubspec.yaml -> dependencies: shared_preferences, cloud_firestore, firebase_auth
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Real-date logic for the 7-day plan.
///
/// - The day the user first opens the plan is saved as the start date (Day 1).
/// - Every new calendar day moves the plan on by one: Day 1, 2, ... 7, then
///   Day 1 again (a new cycle, and "days done" starts from zero).
/// - "Today's" day is calculated from the phone's date every time it is asked,
///   so it always follows the date, online or offline.
///
/// Saved in two places:
/// - On the phone (shared_preferences): always works, even with no internet.
/// - In Firestore users/{uid}/training/plan: backup, so progress survives a
///   reinstall or a new phone.
///     startDate: Timestamp
///     completed: { "2026-10-15": [1, 2, 3] }   (key = date that cycle's Day 1 fell on)
class TrainingProgressService {
  TrainingProgressService._();
  static final TrainingProgressService instance = TrainingProgressService._();

  static const int planLength = 7;

  String? _uid;
  DateTime? _start;
  Map<String, Set<int>> _done = {};

  // ---------- date helpers ----------

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  // UTC dates, so daylight saving can never skip or repeat a day.
  static int _daysBetween(DateTime from, DateTime to) {
    final a = DateTime.utc(from.year, from.month, from.day);
    final b = DateTime.utc(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }

  static String _key(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  // ---------- what the screen asks for (instant, no waiting) ----------

  int _daysSinceStart(DateTime now) {
    final start = _start ?? _dateOnly(now);
    final today = _dateOnly(now);
    if (today.isBefore(start)) return 0; // phone clock moved back
    return _daysBetween(start, today);
  }

  /// 1..7 for the real date.
  int todayDay([DateTime? now]) =>
      _daysSinceStart(now ?? DateTime.now()) % planLength + 1;

  String _cycleKey(DateTime now) {
    final start = _start ?? _dateOnly(now);
    final cycle = _daysSinceStart(now) ~/ planLength;
    return _key(DateTime(start.year, start.month, start.day + cycle * planLength));
  }

  /// Day numbers finished in the current 7-day cycle.
  Set<int> completed([DateTime? now]) =>
      Set<int>.of(_done[_cycleKey(now ?? DateTime.now())] ?? <int>{});

  // ---------- loading and saving ----------

  DocumentReference<Map<String, dynamic>>? get _doc {
    final uid = _uid;
    if (uid == null || uid == 'guest') return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('training')
        .doc('plan');
  }

  /// Call once when the schedule opens. Safe to call again.
  Future<void> load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    if (_uid == uid && _start != null) return;

    _uid = uid;
    _start = null;
    _done = {};
    final today = _dateOnly(DateTime.now());

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1) what is saved on this phone
      DateTime? start;
      final savedStart = prefs.getString('plan_start_$uid');
      if (savedStart != null) start = DateTime.tryParse(savedStart);
      final savedDone = prefs.getString('plan_done_$uid');
      if (savedDone != null) _done = _decode(savedDone);

      // 2) what is saved online (best effort, never blocks for long)
      DateTime? remoteStart;
      try {
        final data = (await _doc?.get().timeout(const Duration(seconds: 6)))?.data();
        final ts = data?['startDate'];
        if (ts is Timestamp) remoteStart = _dateOnly(ts.toDate());
        final remoteDone = data?['completed'];
        if (remoteDone is Map) {
          remoteDone.forEach((k, v) {
            if (v is List) {
              (_done[k as String] ??= <int>{})
                  .addAll(v.map((e) => (e as num).toInt()));
            }
          });
        }
      } catch (_) {}

      // 3) the earliest known start date wins; a brand new user starts today
      if (remoteStart != null && (start == null || remoteStart.isBefore(start))) {
        start = remoteStart;
      }
      start ??= today;
      _start = start;

      await _saveLocal(prefs);
      _syncUp(startDate: start); // fire and forget
    } catch (_) {
      _start ??= today; // never leave the screen without a start date
    }
  }

  /// Saves that [day] was completed in the current cycle.
  Future<void> markCompleted(int day, [DateTime? now]) async {
    final key = _cycleKey(now ?? DateTime.now());
    (_done[key] ??= <int>{}).add(day);

    try {
      await _saveLocal(await SharedPreferences.getInstance());
    } catch (_) {}

    try {
      await _doc?.set(
        {
          'completed': {
            key: FieldValue.arrayUnion([day]),
          },
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Offline: it is already saved on the phone and is pushed on next load.
    }
  }

  Future<void> _saveLocal(SharedPreferences prefs) async {
    final uid = _uid ?? 'guest';
    final start = _start;
    if (start != null) await prefs.setString('plan_start_$uid', _key(start));
    await prefs.setString('plan_done_$uid', _encode(_done));
  }

  Future<void> _syncUp({required DateTime startDate}) async {
    final doc = _doc;
    if (doc == null) return;
    try {
      await doc.set(
        {
          'startDate': Timestamp.fromDate(startDate),
          'completed': {
            for (final e in _done.entries)
              e.key: FieldValue.arrayUnion(e.value.toList()),
          },
        },
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  static String _encode(Map<String, Set<int>> m) =>
      jsonEncode({for (final e in m.entries) e.key: e.value.toList()});

  static Map<String, Set<int>> _decode(String s) {
    try {
      final raw = jsonDecode(s) as Map<String, dynamic>;
      return {
        for (final e in raw.entries)
          e.key: (e.value as List).map((x) => (x as num).toInt()).toSet(),
      };
    } catch (_) {
      return {};
    }
  }
}