import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class day1 extends StatelessWidget {
  const day1({super.key});

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
          "Day 1",
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
                  "Cardio + Core",
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
                    " Cardio (30 minutes):",
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
                "Activity like brisk Walking, Cycling, or Swimming",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.circle, size: 15, color: Colors.red),
                  SizedBox(width: 10),
                  AutoSizeText(
                    " Core( 15 - 30 minutes):",
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
                "Plank : 3 set of 30 seconds",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "Bicycle Crunches : 3 set of 15 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              AutoSizeText(
                "leg Raises: 3 set of 10 reps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              AutoSizeText(
                "Note:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                "Don't run from your Dream , Chase the Dream",
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
                    child: Image.asset("assets/images/workGym.png")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
