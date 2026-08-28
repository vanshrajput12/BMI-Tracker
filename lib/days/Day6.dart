import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class day6 extends StatelessWidget {
  const day6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white)),
        title: AutoSizeText(
          "Day 6",
          style: TextStyle(
            fontFamily: 'poppins',
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AutoSizeText(
                  "Recovery + Strength",
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.circle, size: 15, color: Colors.red),
                  SizedBox(width: 10),
                  AutoSizeText(
                    "Light Activity(40 min):",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Activity like(walking, cycling or swimming).",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.circle, size: 15, color: Colors.red),
                  SizedBox(width: 10),
                  AutoSizeText(
                    "Flexibility Work(20 min):",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Seated Spinal Twist.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Knee-to-chest Stretch.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Butterfly Stretch.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Child's Pose.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AutoSizeText(
                "Note:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                "The clock is ticking.Are you becoming the person you want to be?",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber.shade500,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'poppins'
                ),
              ),
              Center(
                child: Container(
                    margin:  EdgeInsets.only(bottom: 40),
                    height: MediaQuery.of(context).size.height / 4.5,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.asset("assets/images/clock.png")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
