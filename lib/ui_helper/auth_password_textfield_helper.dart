import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPasswordTextFieldHelper extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool obscurePassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const AuthPasswordTextFieldHelper({
    super.key,
    required this.controller,
    this.obscurePassword = true,
    required this.text,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      decoration: InputDecoration(
        hintText: text,

        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(34),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 1.5,
          ),
        ),

        suffixIcon: suffixIcon,
      ),

      validator: validator,
    );
  }
}