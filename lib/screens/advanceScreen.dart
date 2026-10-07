import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';

// ───────────────────────── Design tokens ─────────────────────────
class _C {
  static const bg = Color(0xFF0F0F10);
  static const surface = Color(0xFF1A1A1B);
  static const surfaceHi = Color(0xFF232324);
  static const accent = Color(0xFFFF9800);
  static const ember = Color(0xFFFF6D00);
  static const text = Color(0xFFF5F1EA);
  static const muted = Color(0xFF8E8E90);
}

TextStyle _poppins(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = _C.text,
  double? height,
}) => GoogleFonts.poppins(
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
);

// ───────────────────────── Data ─────────────────────────
enum DayStatus { done, today, upcoming, rest }

/// Static info about one training day: what to show and which page to open.
class _DayInfo {
  final String title;
  final String detail;
  final bool isRest;
  final WidgetBuilder page;

  const _DayInfo({
    required this.title,
    required this.detail,
    required this.page,
    this.isRest = false,
  });
}

/// A day combined with its status for the current week (what the UI renders).
class _DayPlan {
  final int day; // 1..7
  final _DayInfo info;
  final DayStatus status;

  const _DayPlan(this.day, this.info, this.status);
}

// ───────────────────────── Screen ─────────────────────────
class AdvanceScreen extends StatelessWidget {
  const AdvanceScreen({super.key});

  // TODO: replace the titles/details with your real workouts.
  // Day 1 = Monday ... Day 7 = Sunday.
  static final List<_DayInfo> _days = [
    _DayInfo(
      title: 'Chest & triceps',
      detail: '6 exercises · 45 min',
      page: (_) => day1(),
    ),
    _DayInfo(
      title: 'Back & biceps',
      detail: '7 exercises · 50 min',
      page: (_) => day2(),
    ),
    _DayInfo(
      title: 'Legs & core',
      detail: '8 exercises · 55 min',
      page: (_) => day3(),
    ),
    _DayInfo(
      title: 'Shoulders',
      detail: '5 exercises · 40 min',
      page: (_) => day4(),
    ),
    _DayInfo(
      title: 'Full-body conditioning',
      detail: '6 exercises · 35 min',
      page: (_) => day5(),
    ),
    _DayInfo(
      title: 'Mobility & stretch',
      detail: '4 exercises · 25 min',
      page: (_) => day6(),
    ),
    _DayInfo(
      title: 'Rest day',
      detail: 'Recover and refuel',
      page: (_) => day7(),
      isRest: true,
    ),
  ];

  /// Builds this week's plan from the calendar: days before today are done,
  /// today is highlighted, the rest are upcoming (rest days stay "rest").
  List<_DayPlan> _buildPlan() {
    final todayIndex = DateTime.now().weekday - 1; // Mon = 0 ... Sun = 6
    return List.generate(_days.length, (i) {
      final info = _days[i];
      final status = i == todayIndex
          ? DayStatus.today
          : info.isRest
          ? DayStatus.rest
          : i < todayIndex
          ? DayStatus.done
          : DayStatus.upcoming;
      return _DayPlan(i + 1, info, status);
    });
  }

  void _open(BuildContext context, _DayPlan plan) {
    Navigator.push(context, MaterialPageRoute(builder: plan.info.page));
  }

  @override
  Widget build(BuildContext context) {
    final plan = _buildPlan();
    final today = plan.firstWhere((d) => d.status == DayStatus.today);
    final doneCount = plan.where((d) => d.status == DayStatus.done).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _C.bg,
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
            SizedBox(width: 240, child: Divider(color: Colors.white)),
          ],
        ),
      ),
      backgroundColor: _C.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          // Extra bottom padding keeps the last row clear of the floating nav bar.
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 130),
          children: [
            Text(
              '$doneCount of ${plan.length} days done this week',
              style: _poppins(14, color: _C.muted),
            ),
            const SizedBox(height: 18),
            _WeekStrip(plan: plan),
            const SizedBox(height: 26),
            _TodayCard(plan: today, onTap: () => _open(context, today)),
            const SizedBox(height: 26),
            Text('All days', style: _poppins(16, weight: FontWeight.w600)),
            const SizedBox(height: 12),
            // Shows all 7 days, today included (highlighted).
            for (final d in plan)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DayRow(plan: d, onTap: () => _open(context, d)),
              ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────── Week progress strip ─────────────────────
class _WeekStrip extends StatelessWidget {
  final List<_DayPlan> plan;
  const _WeekStrip({required this.plan});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Row(
        children: [
          for (var i = 0; i < plan.length; i++) ...[
            Expanded(
              child: _Segment(status: plan[i].status, progress: _stagger(t, i)),
            ),
            if (i != plan.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  /// Each segment fills in turn as [t] goes 0 → 1.
  double _stagger(double t, int i) => ((t * plan.length) - i).clamp(0.0, 1.0);
}

class _Segment extends StatelessWidget {
  final DayStatus status;
  final double progress;
  const _Segment({required this.status, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: _C.surfaceHi,
        borderRadius: BorderRadius.circular(8),
        border: status == DayStatus.today
            ? Border.all(color: _C.accent, width: 1.2)
            : null,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: status == DayStatus.done ? progress : 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_C.accent, _C.ember]),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────── Today hero card ─────────────────────
class _TodayCard extends StatelessWidget {
  final _DayPlan plan;
  final VoidCallback onTap;
  const _TodayCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final onAccent = Colors.black.withValues(alpha: .75);

    return Material(
      borderRadius:  BorderRadius.circular(28),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFA726), _C.ember],
            ),
            boxShadow: [
              BoxShadow(
                color: _C.accent.withValues(alpha: .28),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today · Day ${plan.day}',
                style: _poppins(13, weight: FontWeight.w500, color: onAccent),
              ),
              const SizedBox(height: 6),
              Text(
                plan.info.title,
                style: _poppins(
                  26,
                  weight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(plan.info.detail, style: _poppins(14, color: onAccent)),
              if (!plan.info.isRest) ...[
                const SizedBox(height: 18),
                const _StartPill(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StartPill extends StatelessWidget {
  const _StartPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, color: _C.accent, size: 22),
          const SizedBox(width: 6),
          Text('Start workout', style: _poppins(14, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ───────────────────── Compact day row ─────────────────────
class _DayRow extends StatelessWidget {
  final _DayPlan plan;
  final VoidCallback onTap;
  const _DayRow({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDone = plan.status == DayStatus.done;
    final isRest = plan.status == DayStatus.rest;
    final isToday = plan.status == DayStatus.today;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isToday ? _C.accent : Colors.white.withValues(alpha: .05),
              width: isToday ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              _DayBadge(day: plan.day, status: plan.status),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.info.title,
                      style: _poppins(
                        15,
                        weight: FontWeight.w600,
                        color: isDone || isRest ? _C.muted : _C.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.info.detail,
                      style: _poppins(12.5, color: _C.muted),
                    ),
                  ],
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _C.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Today',
                    style: _poppins(
                      11,
                      weight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                )
              else
                Icon(
                  isDone
                      ? Icons.check_circle_rounded
                      : isRest
                      ? Icons.bedtime_outlined
                      : Icons.chevron_right_rounded,
                  color: isDone ? _C.accent : _C.muted,
                  size: isDone ? 24 : 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final int day;
  final DayStatus status;
  const _DayBadge({required this.day, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDone = status == DayStatus.done;
    final isRest = status == DayStatus.rest;
    final isToday = status == DayStatus.today;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: isToday
            ? _C.accent
            : isDone
            ? _C.accent.withValues(alpha: .14)
            : _C.surfaceHi,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day',
            style: _poppins(
              10,
              height: 1,
              color: isToday
                  ? Colors.black.withValues(alpha: .75)
                  : isDone
                  ? _C.accent
                  : _C.muted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$day',
            style: _poppins(
              20,
              weight: FontWeight.w700,
              height: 1.1,
              color: isToday
                  ? Colors.black
                  : isDone
                  ? _C.accent
                  : isRest
                  ? _C.muted
                  : _C.text,
            ),
          ),
        ],
      ),
    );
  }
}
