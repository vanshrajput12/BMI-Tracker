import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../ui_helper/auth_mail_textfield_helper.dart';
import '../../ui_helper/snackbar_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    // Empty email
    if (email.isEmpty) {
      SnackBarHelper.show(
        'Please enter your email address.',
        context,
        Colors.red,
      );
    }

    // Email validation
    if (!email.contains('@') || !email.contains('.')) {
      SnackBarHelper.show(
        'Please enter a valid email address.',
        context,
        Colors.red,
      );
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        SnackBarHelper.show(
          'Password reset email sent. Check your inbox.',
          context,
          Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'too-many-requests':
          message = 'Too many requests. Please try again later.';
          break;

        default:
          message = e.message ?? 'Unable to send reset email.';
      }
    } catch (e) {
      SnackBarHelper.show(
        'Something went wrong. Please try again.',
        context,
        Colors.orange,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black),
            ),
          ),
          Positioned(
            top: -180,
            right: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurStyle: BlurStyle.outer)],
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF42030B).withValues(alpha: 0.5),
                    Color(0xFF1A0508),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF3A1A05),
                    Color(0xFF170B02),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Center(
                      child: Lottie.asset(
                        'assets/animations/forgotPassword.json',
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),

                    const SizedBox(height: 35),
                    Center(
                      child: Text(
                        'FORGOT PASSWORD?',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Center(
                      child: AutoSizeText(
                        'Enter your email address and we will send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight(600),
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),
                    Text(
                      'Email Address',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Email TextField
                    AuthEmailTextFieldHelper(
                      controller: _emailController,
                      text: 'Qwerty@gmail.com',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                        onPressed: _isLoading ? null : _sendResetEmail,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'Send Reset Link',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Center(
                      child: TextButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          'Back to Sign In',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
