import 'package:bmi_project/ui_helper/day_button_helper.dart';
import 'package:flutter/material.dart';

import '../days/Day 1.dart';
import '../days/Day2.dart';
import '../days/Day3.dart';
import '../days/Day4.dart';
import '../days/Day5.dart';
import '../days/Day6.dart';
import '../days/Day7.dart';

class AdvanceScreen extends StatelessWidget {
  const AdvanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Training Schedule",
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
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
