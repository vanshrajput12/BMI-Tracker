import 'package:flutter/material.dart';

class day7 extends StatelessWidget {
  const day7({super.key});

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
        title: Text(
          "Day 7",
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
          child: Text(
          "Rest Day",
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),),
            SizedBox(height: 20,),
            Text("It's important to let your body recover. If you feel active, try light stretching or 20-30 minutes walk.",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'poppins',
              color: Colors.amber.shade500
            ),),
              SizedBox(height: 30,),
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.asset("assets/images/thank-you.png")),
              )
            ]
          ),
        ),
      ),
    );
  }
}
