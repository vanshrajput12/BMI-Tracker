import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Weight LOSS screens (your original files)
import '../days/Day 1.dart' show DayWorkoutScreen;
import '../days/Day2.dart' show DayStrengthScreen;
import '../days/Day3.dart' show DayFlexibilityScreen;
import '../days/Day4.dart' show DayHiitScreen;
import '../days/Day5.dart' show DayStrengthTrainingScreen;
import '../days/Day6.dart' show DayRecoveryScreen;
import '../days/Day7.dart' show DayRestScreen;

// Weight GAIN screens
import '../days/WG_Day1.dart' show DayGainWorkoutScreen;
import '../days/WG_Day2.dart' show DayGainStrengthScreen;
import '../days/WG_Day3.dart' show DayGainFlexibilityScreen;
import '../days/WG_Day4.dart' show DayGainHiitScreen;
import '../days/WG_Day5.dart' show DayGainStrengthTrainingScreen;
import '../days/WG_Day6.dart' show DayGainRecoveryScreen;
import '../days/WG_Day7.dart' show DayGainRestScreen;

const _bg = Color(0xFF000000);
const _card = Color(0xFF151515);
const _orange = Color(0xFFFF9800);
const _text = Color(0xFFFFFFFF);

enum Goal { loss, gain }

/// Returns the day screen that matches the chosen goal.
Widget buildDayPage(int day, {required Goal goal}) {
  if (goal == Goal.gain) {
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
  const GoalSelectionScreen(
      {super.key, required this.day, required this.title});

  Future<void> _select(BuildContext context, Goal goal) async {
    final finished = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => buildDayPage(day, goal: goal)),
    );
    // Only close this screen when the day was completed. If the user just
    // pressed back, they return here and can pick the other goal.
    if (finished == true && context.mounted) Navigator.pop(context, true);
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
              Icon(icon, color: _orange, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title,
                    style: t.titleMedium!
                        .copyWith(color: _text, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right_rounded, color: _orange),
            ],
          ),
        ),
      ),
    );
  }
}