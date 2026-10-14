import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';
import '../screens/trainingScheduleScreen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/notification_page.dart';
import '../screens/profile_screen.dart';
import '../screens/step_counter_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  // Later you can load these from Firestore.
  final Set<int> completedDays = {1, 2};
  final int today = 3;

  void _openDay(int day) {
    final Widget page = switch (day) {
      1 => const DayWorkoutScreen(),
      2 => const DayStrengthScreen(),
      3 => const DayFlexibilityScreen(),
      4 => const DayHiitScreen(),
      5 => const DayStrengthTrainingScreen(),
      6 => const DayRecoveryScreen(),
      _ => const DayRestScreen(),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // A getter (not a final field) so it can use `context` and state.
  List<Widget> get pages => [
    const DashboardScreen(),
    const StepCounterScreen(),
    TrainingScheduleScreen(
      completed: completedDays,
      today: today,
      onDayTap: _openDay,
    ),
    const NotificationPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: currentIndex,
        indicatorColor: Colors.white,
        unselectedItemColor: Colors.white70,
        borderWidth: 1.5,
        outlineBorderColor: Colors.white.withValues(alpha: 0.7),
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          CrystalNavigationBarItem(
            icon: Icons.space_dashboard_rounded,
            selectedColor:  Colors.amber,
          ),
          CrystalNavigationBarItem(
            icon: Icons.directions_run_rounded,
            selectedColor:  Colors.amber,
          ),
          CrystalNavigationBarItem(
            icon: Icons.analytics_rounded,
            selectedColor:  Colors.amber,
          ),
          CrystalNavigationBarItem(
            icon: Icons.notifications,
            selectedColor:  Colors.amber,
          ),
          CrystalNavigationBarItem(
            icon: CupertinoIcons.person_fill,
            selectedColor:  Colors.amber,
          ),
        ],
      ),
    );
  }
}
