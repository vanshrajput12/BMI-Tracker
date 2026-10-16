// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';
import '../services/training_progess_service.dart';

// Calm, mostly neutral palette. Coral is used only for "today",
// sage green only for "done". No amber on this screen.
const _bg = Color(0xFF0E0E10);
const _surface = Color(0xFF16171A);
const _surfaceHi = Color(0xFF1C1D21);
const _line = Color(0x14FFFFFF);
const _text = Color(0xFFF2F0F5);
const _muted = Color(0xFF8C8A94);
const _coral = Color(0xFFFF6B5A);
const _sage = Color(0xFFFFBF00);

class WorkoutDay {
  final int number;
  final String title;
  final List<String> focus;
  final String duration;
  final IconData icon;
  final bool isRest;
  const WorkoutDay({
    required this.number,
    required this.title,
    required this.focus,
    required this.duration,
    required this.icon,
    this.isRest = false,
  });
}

// Durations are a range across the 1-2 kg and 5 kg goal plans.
const kWeekPlan = <WorkoutDay>[
  WorkoutDay(
    number: 1,
    title: 'Cardio + Core',
    focus: ['Cardio', 'Core'],
    duration: '55-85 min',
    icon: Icons.directions_run,
  ),
  WorkoutDay(
    number: 2,
    title: 'Full Strength Training',
    focus: ['Strength', 'Full body'],
    duration: '40-55 min',
    icon: Icons.fitness_center,
  ),
  WorkoutDay(
    number: 3,
    title: 'Cardio + Flexibility',
    focus: ['Cardio', 'Stretching'],
    duration: '40-57 min',
    icon: Icons.self_improvement,
  ),
  WorkoutDay(
    number: 4,
    title: 'HIIT',
    focus: ['Intervals', 'Fat burn'],
    duration: '40-55 min',
    icon: Icons.bolt,
  ),
  WorkoutDay(
    number: 5,
    title: 'Strength Training',
    focus: ['Strength', 'Arms and legs'],
    duration: '40-55 min',
    icon: Icons.fitness_center,
  ),
  WorkoutDay(
    number: 6,
    title: 'Recovery + Strength',
    focus: ['Light activity', 'Flexibility'],
    duration: '55-65 min',
    icon: Icons.spa_outlined,
  ),
  WorkoutDay(
    number: 7,
    title: 'Rest Day',
    focus: ['Recover'],
    duration: 'Rest',
    icon: Icons.bedtime_outlined,
    isRest: true,
  ),
];

/// The Training Schedule screen. It looks after everything by itself:
/// it reads the real date, works out which day is "today", moves to the next
/// day when the date changes, opens the day screens and saves progress.
/// Use it anywhere as: const TrainingScheduleScreen()
class TrainingScheduleScreen extends StatefulWidget {
  const TrainingScheduleScreen({super.key});

  @override
  State<TrainingScheduleScreen> createState() => _TrainingScheduleScreenState();
}

class _TrainingScheduleScreenState extends State<TrainingScheduleScreen>
    with WidgetsBindingObserver {
  final _service = TrainingProgressService.instance;
  Timer? _midnightTimer;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _midnightTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    await _service.load();
    if (!mounted) return;
    setState(() => _ready = true);
    _scheduleMidnight();
  }

  // The user comes back to the app (for example on a new day): rebuild
  // with the real date.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
      _scheduleMidnight();
    }
  }

  // The app is left open past midnight: move to the next day by itself.
  void _scheduleMidnight() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer = Timer(
      nextMidnight.difference(now) + const Duration(seconds: 1),
          () {
        if (!mounted) return;
        setState(() {});
        _scheduleMidnight();
      },
    );
  }

  Future<void> _openDay(int day) async {
    final Widget page = switch (day) {
      1 => const DayWorkoutScreen(),
      2 => const DayStrengthScreen(),
      3 => const DayFlexibilityScreen(),
      4 => const DayHiitScreen(),
      5 => const DayStrengthTrainingScreen(),
      6 => const DayRecoveryScreen(),
      _ => const DayRestScreen(),
    };

    // The day screens return true from "Complete Day", nothing on back.
    final finished = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    if (finished != true) return;

    await _service.markCompleted(day);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    final now = DateTime.now(); // read again on every rebuild
    return _ScheduleView(
      today: _service.todayDay(now),
      completed: _service.completed(now),
      onDayTap: _openDay,
    );
  }
}

/// The screen design (unchanged). It only shows what it is given.
class _ScheduleView extends StatelessWidget {
  final List<WorkoutDay> days;
  final Set<int> completed; // day numbers
  final int today; // day number
  final void Function(int day) onDayTap;

  const _ScheduleView({
    this.days = kWeekPlan,
    required this.completed,
    required this.today,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    final todayDay = days.firstWhere(
          (d) => d.number == today,
      orElse: () => days.first,
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,

        title: Column(
          children: [
            Text(
              'TRAINING SCHEDULE',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            SizedBox(width: 220, child: Divider(color: Colors.white)),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          // Extra bottom padding so the floating nav bar never covers content.
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          children: [
            _todayCard(t, todayDay),
            const SizedBox(height: 28),
            Text(
              'All days',
              style: t.titleMedium!.copyWith(
                color: _text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...days.map(
                  (d) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _dayRow(t, d),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todayCard(TextTheme t, WorkoutDay d) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1A19), Color(0xFF17181B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _coral.withOpacity(0.25)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -10,
            child: Icon(
              d.icon,
              size: 150,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today  |  Day ${d.number}',
                  style: t.bodyMedium!.copyWith(
                    color: _coral,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  d.title,
                  style: t.headlineMedium!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(t, Icons.timer_outlined, d.duration),
                    ...d.focus.map((f) => _chip(t, null, f)),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => onDayTap(d.number),
                    icon: Icon(
                      d.isRest
                          ? Icons.bedtime_outlined
                          : Icons.play_arrow_rounded,
                      size: 24,
                    ),
                    label: Text(
                      d.isRest ? 'View rest day' : 'Start workout',
                      style: t.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _text,
                      foregroundColor: const Color(0xFF111113),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(TextTheme t, IconData? icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: _muted),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: t.bodySmall!.copyWith(color: _text.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }

  Widget _dayRow(TextTheme t, WorkoutDay d) {
    final done = completed.contains(d.number);
    final isToday = d.number == today;

    final badgeBg = isToday
        ? _coral
        : done
        ? _sage.withOpacity(0.12)
        : Colors.white.withOpacity(0.06);
    final badgeFg = isToday ? Colors.white : (done ? _sage : _text);

    return Material(
      color: isToday ? _surfaceHi : _surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onDayTap(d.number),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isToday ? _coral.withOpacity(0.45) : _line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Day',
                      style: t.labelSmall!.copyWith(
                        color: badgeFg.withOpacity(0.8),
                        height: 1,
                      ),
                    ),
                    Text(
                      '${d.number}',
                      style: t.titleLarge!.copyWith(
                        color: badgeFg,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSmall!.copyWith(
                        color: done ? _muted : _text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      d.isRest
                          ? 'Rest  |  stretch or easy walk'
                          : '${d.focus.join(', ')}  |  ${d.duration}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall!.copyWith(color: _muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _trailing(t, done, isToday),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trailing(TextTheme t, bool done, bool isToday) {
    if (done) {
      return const Icon(Icons.check_circle_rounded, color: _sage, size: 26);
    }
    if (isToday) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _coral.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Today',
          style: t.bodySmall!.copyWith(
            color: _coral,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const Icon(Icons.chevron_right_rounded, color: _muted, size: 26);
  }
}