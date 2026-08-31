import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  static const Color _backgroundColor = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Text(
            "NOTIFICATION",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),SizedBox(width:180,child: Divider(color: Colors.white,)),
          SizedBox(height: 350),
          Center(
            child: Text(
              "No Notification",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight(600)),
            ),
          ),
        ],
      ),
    );
  }
}
