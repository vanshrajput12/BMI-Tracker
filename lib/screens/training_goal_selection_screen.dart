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
const _red = Color(0xFFFF4D3D);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);

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
              Text(title, style: t.bodyMedium!.copyWith(color: _amber)),
              const SizedBox(height: 6),
              Text('What is your goal?',
                  style: t.headlineMedium!.copyWith(
                      color: _text, fontWeight: FontWeight.w700, height: 1.2)),
              const SizedBox(height: 8),
              Text(
                'Your workout will be matched to the goal you choose.',
                style: t.bodyMedium!.copyWith(color: _muted, height: 1.4),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: _GoalCard(
                  t: t,
                  icon: Icons.trending_down_rounded,
                  title: 'Weight Loss',
                  subtitle: 'Burn fat with cardio, intervals and core work.',
                  tags: const ['Higher cardio', 'Calorie burn'],
                  onTap: () => _select(context, Goal.loss),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _GoalCard(
                  t: t,
                  icon: Icons.trending_up_rounded,
                  title: 'Weight Gain',
                  subtitle: 'Build muscle with heavier sets and less cardio.',
                  tags: const ['More strength', 'Muscle build'],
                  onTap: () => _select(context, Goal.gain),
                ),
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
  final String subtitle;
  final List<String> tags;
  final VoidCallback onTap;

  const _GoalCard({
    required this.t,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            // Mostly amber, with only a slight hint of red at the far corner.
            gradient: LinearGradient(
              colors: [
                _amber.withOpacity(0.22),
                _card,
                _red.withOpacity(0.07),
              ],
              stops: const [0.0, 0.65, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: _amber.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: _amber, size: 30),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: _amber),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: t.titleLarge!.copyWith(
                          color: _text, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style: t.bodyMedium!.copyWith(color: _muted, height: 1.4)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags
                        .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(s,
                          style: t.bodySmall!.copyWith(color: _text)),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}