import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class day4 extends StatelessWidget {
  const day4({super.key});

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
          "Day 4",
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
                  "HIIT(High-Intensity Interval Training)",
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
                    "Warm Up(5-10 minutes):",
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
                "Light Cardio(Jumping or Walking)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.circle, size: 15, color: Colors.red),
                  SizedBox(width: 10),
                  AutoSizeText(
                    "HIIT WorkOut(30-40 min):",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 19,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Jumping Squats.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Mountain Climbers.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Burpees.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Jumping Jacks.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AutoSizeText(
                "Note:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                "Your mind is your strongest muscle",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber.shade500,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'poppins'
                ),
              ),
        
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.asset("assets/images/workout2.png")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
