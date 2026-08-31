import 'package:flutter/material.dart';

class DayButtonHelper extends StatelessWidget {
  static const Color _cardColor = Color(0xFF151515);
  static const Color _borderColor = Color(0xFF292929);

  final String text;
  final GestureTapCallback onTap;
  const DayButtonHelper({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(26),
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: _borderColor)
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
