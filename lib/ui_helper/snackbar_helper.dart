import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarHelper {
  static void show(String message,
      BuildContext context,
      Color? color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(message,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight(600)
              )),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
