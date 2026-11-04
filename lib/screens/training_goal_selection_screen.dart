import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';
import '../days/WG_Day1.dart';
import '../days/WG_Day2.dart';
import '../days/WG_Day3.dart';
import '../days/WG_Day4.dart';
import '../days/WG_Day5.dart';
import '../days/WG_Day6.dart';
import '../days/WG_Day7.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _border = Color(0xFF2C2C2E);
const _orange = Color(0xFFFF8A1F);
const _orangeTint = Color(0xFF3A2514);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);

enum Goal { loss, gain }

/// Returns the right screen for the selected day AND goal.
Widget buildDayPage(int day, {required Goal goal}) {
  if (goal == Goal.loss) {
    return switch (day) {
      1 => const DayWorkoutScreen(),
      2 => const DayStrengthScreen(),
      3 => const DayFlexibilityScreen(),
      4 => const DayHiitScreen(),
      5 => const DayStrengthTrainingScreen(),
      6 => const DayRecoveryScreen(),
      _ => const DayRestScreen(),
    };
  }

  return switch (day) {
    1 => const DayGainWorkoutScreen(),
    2 => const DayGainStrengthScreen(),
    3 => const DayGainFlexibilityScreen(),
    4 => const DayGainHiitScreen(),
    5 => const DayGainStrengthTrainingScreen(),
    6 => const DayGainRecoveryScreen(),
    _ => const DayGainRestScreen(),
  };
}

class GoalSelectionScreen extends StatelessWidget {
  final int day;
  final String title;
  const GoalSelectionScreen(
      {super.key, required this.day, required this.title});

  Future<void> _select(BuildContext context, Goal goal) async {
    final finished = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => buildDayPage(day, goal: goal)),
    );
    // Pass "Complete Day" result back to the schedule screen.
    if (context.mounted) Navigator.pop(context, finished);
  }

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: const BackButton(color: _text),
        title: Text('Day $day',
            style: t.titleLarge!
                .copyWith(color: _text, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            // Small orange label
            Row(
              children: [
                Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title.isEmpty ? 'TODAY' : title.toUpperCase(),
                  style: t.labelMedium!.copyWith(
                    color: _orange,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Main heading
            Text(
              'What is your goal?',
              style: t.headlineMedium!.copyWith(
                color: _text,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pick one and we\'ll build today\'s workout around it.',
              style: t.bodySmall!.copyWith(color: _muted, height: 1.5),
            ),
            const SizedBox(height: 24),

            _GoalCard(
              t: t,
              icon: Icons.trending_down_rounded,
              title: 'Weight Loss',
              subtitle: 'Burn calories and build stamina',
              onTap: () => _select(context, Goal.loss),
            ),
            const SizedBox(height: 12),
            _GoalCard(
              t: t,
              icon: Icons.trending_up_rounded,
              title: 'Weight Gain',
              subtitle: 'Build muscle and gain healthy weight',
              onTap: () => _select(context, Goal.gain),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final TextTheme t;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GoalCard({
    required this.t,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: _orange.withOpacity(0.22)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF38241A), // warm brown
            _card,
            Color(0xFF2A1A1C), // very slight red hint
          ],
          stops: [0.0, 0.65, 1.0],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          splashColor: _orange.withOpacity(0.12),
          highlightColor: _orange.withOpacity(0.06),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _orangeTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _orange, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: t.titleSmall!.copyWith(
                              color: _text, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall!
                              .copyWith(color: _muted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: _orange, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}