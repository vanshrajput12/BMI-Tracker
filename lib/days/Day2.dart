import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class day2 extends StatelessWidget {
  const day2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white)),
        title: AutoSizeText(
          "Day 2",
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
                  " Full Strength Training",
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
                    "Warm Up(5 -10 minutes):",
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
                "Light Cardio(Cycling or Walking)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.circle, size: 15, color: Colors.red),
                  SizedBox(width: 10),
                  AutoSizeText(
                    "Strength Train(30 min):", maxLines: 5, minFontSize: 16,
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
                "Squats : 3 set of 15 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Dumbbell Rows : 12 -15 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Push-Ups: 3 set of 10 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Dumbbell Shoulder-Press : 12 -15 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AutoSizeText(
                "Note:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                "Once you are exercising regularly , the hardest thing is to stop it .",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.amber.shade500,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'poppins'
                ),
              ),
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.asset("assets/images/training.png")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
