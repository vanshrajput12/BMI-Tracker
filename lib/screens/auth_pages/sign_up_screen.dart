import 'package:bmi_project/ui_helper/auth_mail_textField_helper.dart';
import 'package:bmi_project/ui_helper/auth_password_textField_helper.dart';
import 'package:bmi_project/ui_helper/snackBar_helper.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToPolicy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }



  Future<void> _createAccount() async {
    debugPrint('Firebase Project ID: ${Firebase.app().options.projectId}');
    debugPrint('Firebase App ID: ${Firebase.app().options.appId}');
    if (!_formKey.currentState!.validate()) {
      SnackBarHelper.show(
        'Please enter your email and password.',
        context,
        Colors.red,
      );
      return;
    }

    if (!_agreedToPolicy) {
      SnackBarHelper.show(
        'Please agree to the Privacy Policy.',
        context,
        Colors.red,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final user = credential.user;

      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());
      }

      if (!mounted) return;
      SnackBarHelper.show(
        'Account created successfully!',
        context,
        Colors.green,
      );
      Navigator.pushReplacementNamed(context, '/details');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          SnackBarHelper.show(
            'An account already exists with this email.',
            context,
            Colors.orange,
          );
          break;

        case 'invalid-email':
          SnackBarHelper.show(
            'Please enter a valid email address.',
            context,
            Colors.red,
          );
          break;

        case 'weak-password':
          SnackBarHelper.show('Password is too weak.', context, Colors.orange);
          break;

        case 'network-request-failed':
          SnackBarHelper.show(
            'Please check your internet connection.',
            context,
            Colors.red,
          );

          break;

        default:
          SnackBarHelper.show(
            'Could not create your account.',
            context,
            Colors.red,
          );
      }
    } catch (e) {
      SnackBarHelper.show(
        'Something went wrong. Please try again.',
        context,
        Colors.red,
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
      resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Welcome User',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'CREATE ACCOUNT',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 28),
                    Text(
                      'Personal Information',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight(600),
                        fontSize: 16,
                      ),
                    ),

                    // Name field
                    const SizedBox(height: 15),
                    AuthEmailTextFieldHelper(
                      controller: _nameController,
                      text: 'Your Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Your Name is required';
                        }

                        return null;
                      },
                    ),

                    // Email field
                    const SizedBox(height: 16),
                    AuthEmailTextFieldHelper(
                      controller: _emailController,
                      text: 'Email address',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    // Password field
                    const SizedBox(height: 16),
                    AuthPasswordTextFieldHelper(
                      controller: _passwordController,
                      text: 'Password',
                      obscurePassword: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    // Confirm password field
                    const SizedBox(height: 16),
                    AuthPasswordTextFieldHelper(
                      controller: _confirmPasswordController,
                      text: 'Confirm password',
                      obscurePassword: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToPolicy,
                          activeColor: Colors.orange,
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _agreedToPolicy = value ?? false;
                                  });
                                },
                        ),

                        Expanded(
                          child: Text(
                            'I have read and agreed to the Privacy Policy',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight(500),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),

                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Continue',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight(600),
                              fontSize: 13,
                            ),
                          ),

                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                color: Colors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
