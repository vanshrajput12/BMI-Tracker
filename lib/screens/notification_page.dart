import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
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
              "NOTIFICATION",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 180, child: Divider(color: Colors.white)),
          ],
        ),
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "No Notification",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight(600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
