import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayButtonHelper extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  const DayButtonHelper({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'poppins',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
