import 'package:bmi_project/bottomNav/bottom_nav.dart';
import 'package:bmi_project/ui_helper/snackBar_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui_helper/auth_mail_textField_helper.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _gender = 'Male';

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // CONVERT WEIGHT TO KG
  double? get _weightInKg {
    final value = double.tryParse(_weightController.text.trim());
    if (value == null) return null;
    if (_weightUnit == 'lb') {
      return value / 2.205;
    }
    return value;
  }

  // CONVERT HEIGHT TO CM
  double? get _heightInCm {
    final value = double.tryParse(_heightController.text.trim());
    if (value == null) return null;
    if (_heightUnit == 'in') {
      return value * 2.54;
    }
    return value;
  }

  // to get the first letter of username .
  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'U';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // Main functionality
  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      SnackBarHelper.show('User session expired. Please login again.', context, Colors.red);

      return;
    }
    final weightKg = _weightInKg;
    final heightCm = _heightInCm;
    if (weightKg == null || heightCm == null) {
      SnackBarHelper.show('Please enter valid body measurements.', context, Colors.red);
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final userRef = firestore.collection('users').doc(firebaseUser.uid);
      final name = _nameController.text.trim();

      final userData = {
        'name': name,
        'email': firebaseUser.email ?? '',
        'initials': _getInitials(name),
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': _gender,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save user profile
      await userRef.set(userData, SetOptions(merge: true));

      // Save first/current weight in history
      await userRef.collection('weightEntries').add({
        'weightKg': weightKg,
        'date': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      SnackBarHelper.show('Your details have been saved.', context, Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseException catch (e) {
      SnackBarHelper.show('Unable to save your details.', context, Colors.red);
    } catch (e) {
      SnackBarHelper.show('Something went wrong. Please try again.', context,Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _unitToggle({
    required String selected,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.black :Colors.white ,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(34),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(34),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(34),
        borderSide: const BorderSide(color: Colors.orange),
      ),
    );
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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
                    'USER DETAIL',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: const LinearProgressIndicator(
                            value: 0.66,
                            minHeight: 5,
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Text(
                    'Tell us about yourself !',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'We will use this information to calculate your BMI.',
                    style: GoogleFonts.poppins(fontSize: 13,  fontWeight : FontWeight(600),color: Colors.grey),
                  ),

                  const SizedBox(height: 28),
                  AuthEmailTextFieldHelper(
                    controller: _nameController,
                    text: 'Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),



                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AuthEmailTextFieldHelper(
                          controller: _weightController,
                          text: "weight",

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final number = double.tryParse(value.trim());
                            if (number == null) {
                              return 'Numbers only';
                            }
                            if (number <= 0 || number > 500) {
                              return 'Invalid weight';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: _unitToggle(
                          selected: _weightUnit,
                          options: const ['kg', 'lb'],
                          onSelect: (value) {
                            setState(() {
                              _weightUnit = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),


                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AuthEmailTextFieldHelper(
                          controller: _heightController,
                          text: "Height",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final number = double.tryParse(value.trim());
                            if (number == null) {
                              return 'Numbers only';
                            }
                            if (number <= 0 || number > 300) {
                              return 'Invalid height';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: _unitToggle(
                          selected: _heightUnit,
                          options: const ['cm', 'in'],
                          onSelect: (value) {
                            setState(() {
                              _heightUnit = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 20,),
                   Divider(),

                  // GENDER
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    dropdownColor: Colors.grey.shade800,
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight(600)),
                    decoration: _fieldDecoration('Select gender'),
                    items: const ['Male', 'Female', 'Other'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender),  );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),

                      onPressed: _isSaving ? null : _saveAndContinue,
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Continue',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),]
      ),
    );
  }
}
