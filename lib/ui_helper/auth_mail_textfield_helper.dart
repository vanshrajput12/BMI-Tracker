import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthEmailTextFieldHelper extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  const AuthEmailTextFieldHelper({super.key, required this.controller, required this.text, required this.validator, this.suffixIcon});

  @override
  State<AuthEmailTextFieldHelper> createState() => _AuthEmailTextFieldHelperState();
}

class _AuthEmailTextFieldHelperState extends State<AuthEmailTextFieldHelper> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
        style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight(600)
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.text,
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight(600),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          suffixIcon: widget.suffixIcon,
        ),
        validator: widget.validator
    );
  }
}