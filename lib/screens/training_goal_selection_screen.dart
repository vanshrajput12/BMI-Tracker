import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);

enum Goal { loss, gain }

/// Returns the right day screen. The goal will be passed in the next step.
Widget buildDayPage(int day, {Goal? goal}) {
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

class GoalSelectionScreen extends StatelessWidget {
  final int day;
  final String title;
  const GoalSelectionScreen({super.key, required this.day, required this.title});

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What is your goal?',
                  style: t.headlineSmall!
                      .copyWith(color: _text, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              _GoalCard(
                t: t,
                icon: Icons.trending_down_rounded,
                title: 'Weight Loss',
                onTap: () => _select(context, Goal.loss),
              ),
              const SizedBox(height: 14),
              _GoalCard(
                t: t,
                icon: Icons.trending_up_rounded,
                title: 'Weight Gain',
                onTap: () => _select(context, Goal.gain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final TextTheme t;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _GoalCard({
    required this.t,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
          child: Row(
            children: [
              Icon(icon, color: _amber, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title,
                    style: t.titleMedium!
                        .copyWith(color: _text, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right_rounded, color: _amber),
            ],
          ),
        ),
      ),
    );
  }
}