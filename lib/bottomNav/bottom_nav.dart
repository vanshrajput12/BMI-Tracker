
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/advanceScreen.dart';
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
  final List<Widget> pages = [
    const DashboardScreen(),
    const StepCounterScreen(),
    const AdvanceScreen(),
    const NotificationPage(),
    const ProfileScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: currentIndex,
        indicatorColor: Colors.white,
        unselectedItemColor: Colors.white70,
        borderWidth: 1.5,

        outlineBorderColor: Colors.white.withValues(alpha: 0.7),

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          CrystalNavigationBarItem(
            icon: Icons.space_dashboard_rounded,
            selectedColor: Colors.orange,
          ),

          CrystalNavigationBarItem(
            icon: Icons.directions_run_rounded,
            selectedColor: Colors.orange,
          ),

          CrystalNavigationBarItem(
            icon: Icons.analytics_rounded,
            selectedColor: Colors.orange,
          ),

          CrystalNavigationBarItem(
            icon: Icons.notifications,
            selectedColor: Colors.orange,
          ),

          CrystalNavigationBarItem(
            icon: CupertinoIcons.person_fill,
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}