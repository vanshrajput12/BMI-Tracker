import 'package:bmi_project/ui_helper/day_button_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';

class AdvanceScreen extends StatelessWidget {
  const AdvanceScreen({super.key});
  static const Color _backgroundColor = Color(0xFF111111);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
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
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 30),
            DayButtonHelper(
              text: "DAY 1 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day1()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 2 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day2()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 3 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day3()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 4 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day4()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 5 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day5()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 6 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day6()),
                );
              },
            ),
            SizedBox(height: 20),
            DayButtonHelper(
              text: "DAY 7 ",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day7()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
