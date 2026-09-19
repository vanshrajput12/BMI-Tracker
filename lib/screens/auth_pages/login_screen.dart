import 'package:bmi_project/screens/auth_pages/sign_up_screen.dart';
import 'package:bmi_project/ui_helper/auth_mail_textField_helper.dart';
import 'package:bmi_project/ui_helper/auth_password_textField_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _agreedToPolicy = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/bottom-nav');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'This email is not registered.';
          break;

        case 'wrong-password':
          message = 'Incorrect password.';
          break;

        case 'invalid-credential':
          message = 'Email or password is incorrect.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = e.message ?? 'Login failed.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // ------------------------------------------------------------
      // 1. Google Sign-In
      // ------------------------------------------------------------

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '246066529696-8ebfhta3m08bd5frsfngbsp73umgr56a.apps.googleusercontent.com',
      );
      // Open Google account selector
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // ------------------------------------------------------------
      // 2. Get Google authentication
      // ------------------------------------------------------------

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      debugPrint('Google ID Token: ${googleAuth.idToken != null}');

      if (googleAuth.idToken == null) {
        throw Exception('Google ID token is null');
      }

      // ------------------------------------------------------------
      // 3. Create Firebase credential
      // ------------------------------------------------------------

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // ------------------------------------------------------------
      // 4. Firebase Login
      // ------------------------------------------------------------

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Firebase user is null');
      }

      // ------------------------------------------------------------
      // 5. VERY IMPORTANT
      // Check whether Firebase created a NEW account
      // ------------------------------------------------------------

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (!mounted) return;

      // ------------------------------------------------------------
      // 6. NEW USER
      // ------------------------------------------------------------

      if (isNewUser) {
        _showSnackBar('Google account created successfully!');

        Navigator.pushReplacementNamed(context, '/details');

        return;
      }

      // ------------------------------------------------------------
      // 7. EXISTING USER
      // ------------------------------------------------------------

      _showSnackBar('Welcome back!');

      Navigator.pushReplacementNamed(context, '/bottom-nav');
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      _showSnackBar('Google Sign-In failed: ${e.description ?? e.code}');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'account-exists-with-different-credential') {
        _showSnackBar(
          'This email already has an account. '
          'Please sign in using your existing method.',
        );
      } else {
        _showSnackBar('Firebase error: ${e.message ?? e.code}');
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('GOOGLE LOGIN ERROR');
      debugPrint('$e');
      debugPrint('=================================');

      if (!mounted) return;

      _showSnackBar('Google Sign-In failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openSignup() {
    if (_isLoading) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _openForgotPassword() {
    if (_isLoading) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'SIGN IN',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email field
                    AuthEmailTextFieldHelper(
                      controller: _emailController,
                      text: 'Qwerty@gmail.com',
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

                    const SizedBox(height: 16),

                    // Password field
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _openForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

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
                        onPressed: _isLoading ? null : _signInWithEmail,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          TextButton(
                            onPressed: _isLoading ? null : _openSignup,
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                        onPressed: _isLoading ? null : _signInWithGoogle,
                        icon: const Icon(
                          Icons.g_mobiledata,
                          size: 30,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Sign in with Google',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
