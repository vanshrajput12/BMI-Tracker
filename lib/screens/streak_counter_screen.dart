import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakScreen extends StatelessWidget {
  final int streak; // from _streakService.getStreak() / updateStreak()
  final int steps; // today's steps
  final int goal; // daily goal (10,000)

  const StreakScreen({
    super.key,
    required this.streak,
    required this.steps,
    this.goal = 10000,
  });

  static const _bg = Color(0xFF111111);
  static const _card = Color(0xFF151515);
  static const _orange = Color(0xFFE8590C);
  static const _gold = Color(0xFFF0C27B);
  static const _cream = Color(0xFFEFE5D6);

  bool get _goalHitToday => steps >= goal;

  /// A streak is consecutive days, so the active days are simply the last
  /// `streak` days ending today (if goal hit) or yesterday (if not yet).
  Set<DateTime> get _activeDays {
    final now = DateTime.now();
    final end = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: _goalHitToday ? 0 : 1));
    return {for (var i = 0; i < streak; i++) end.subtract(Duration(days: i))};
  }

  int get _nextMilestone {
    for (final m in [3, 7, 14, 30, 60, 100]) {
      if (m > streak) return m;
    }
    return streak + 10;
  }

  String get _badgeName {
    switch (_nextMilestone) {
      case 3:
        return 'Three-Peat';
      case 7:
        return 'Week Warrior';
      case 14:
        return 'Fortnight Fighter';
      case 30:
        return 'Monthly Master';
      default:
        return 'Streak Legend';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _hero(context),
          const SizedBox(height: 16),
          _weekRow(),
          const SizedBox(height: 28),
          _badgeCard(),
          const Spacer(),
          _cta(context),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    final remaining = (goal - steps).clamp(0, goal);
    final message = _goalHitToday
        ? 'You hit your $goal step goal today. Come back tomorrow to keep it burning.'
        : 'Walk $remaining more steps today to ${streak == 0 ? 'start' : 'keep'} your streak burning.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 16,
        24,
        32,
      ),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.6),
          radius: 1.0,
          colors: [Color(0xFF7A5128), Color(0xFF3A2216), Color(0xFF1F130D)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('🔥', style: TextStyle(fontSize: 88)),
          const SizedBox(height: 40),
          Text(
            '$streak',
            style: GoogleFonts.poppins(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFF7EFE4),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'days of walking, unbroken',
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: _gold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekRow() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final active = _activeDays;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final day = monday.add(Duration(days: i));
          return Column(
            children: [
              Text(
                labels[i],
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              _dayCircle(done: active.contains(day), isToday: day == today),
            ],
          );
        }),
      ),
    );
  }

  Widget _dayCircle({required bool done, required bool isToday}) {
    const size = 44.0;
    if (done) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white),
      );
    }
    if (isToday) {
      return CustomPaint(
        painter: _DashedCirclePainter(color: _orange),
        child: const SizedBox(width: size, height: size),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.5),
      ),
    );
  }

  Widget _badgeCard() {
    final remaining = _nextMilestone - streak;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFF1A110D),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$remaining day${remaining == 1 ? '' : 's'} to your next badge',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hit a $_nextMilestone day streak to unlock the $_badgeName badge.',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cta(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _cream,
              foregroundColor: const Color(0xFF2A1A12),
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Keep the streak alive',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final r = size.width / 2 - 1;
    final c = Offset(size.width / 2, size.height / 2);
    const dashes = 16;
    const sweep = 6.2831853 / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        i * sweep,
        sweep * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
