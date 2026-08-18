import 'package:bmi_project/models/user_profile_model.dart';
import 'package:bmi_project/pages/auth_pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProfile? _profile;

  String _gender = 'Male';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final document = await _firestore.collection('users').doc(user.uid).get();
      if (!document.exists) {
        setState(() {
          _isLoading = false;
        });

        return;
      }

      final profile = UserProfile.fromMap(document.id, document.data()!);

      _nameController.text = profile.name;

      _weightController.text = profile.weightKg.toString();

      _heightController.text = profile.heightCm.toString();

      _gender = profile.gender.isEmpty ? 'Male' : profile.gender;

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('SETTINGS LOAD ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'U';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = _auth.currentUser;

    if (user == null) {
      _showMessage('Please login again.');
      return;
    }

    final name = _nameController.text.trim();

    final weight = double.parse(_weightController.text.trim());

    final height = double.parse(_heightController.text.trim());

    setState(() {
      _isSaving = true;
    });

    try {
      final userRef = _firestore.collection('users').doc(user.uid);

      await userRef.update({
        'name': name,
        'initials': _getInitials(name),
        'weightKg': weight,
        'heightCm': height,
        'gender': _gender,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add the new weight to history.
      await userRef.collection('weightEntries').add({
        'weightKg': weight,
        'date': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showMessage('Profile updated successfully.');

      await _loadProfile();
    } catch (e) {
      debugPrint('UPDATE PROFILE ERROR: $e');

      _showMessage('Unable to update profile.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
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
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                if (_profile != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue.shade700,

                          child: Text(
                            _profile!.initials,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profile!.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                _profile!.email,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 28),

                Text(
                  'Personal information',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 10),

                // NAME
                TextFormField(
                  controller: _nameController,

                  style: GoogleFonts.poppins(color: Colors.white),

                  decoration: _fieldDecoration('Name'),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // EMAIL
                TextFormField(
                  initialValue: _profile?.email ?? '',
                  readOnly: true,
                  style: GoogleFonts.poppins(color: Colors.grey),
                  decoration: _fieldDecoration('Email'),
                ),

                const SizedBox(height: 28),

                Text(
                  'Body data',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 10),

                // WEIGHT
                TextFormField(
                  controller: _weightController,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  style: GoogleFonts.poppins(color: Colors.white),

                  decoration: _fieldDecoration('Weight (kg)'),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Weight is required';
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

                const SizedBox(height: 14),

                // HEIGHT
                TextFormField(
                  controller: _heightController,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  style: GoogleFonts.poppins(color: Colors.white),

                  decoration: _fieldDecoration('Height (cm)'),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Height is required';
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

                const SizedBox(height: 14),

                // GENDER
                DropdownButtonFormField<String>(
                  initialValue: _gender,

                  dropdownColor: Colors.grey.shade800,

                  style: GoogleFonts.poppins(color: Colors.white),

                  decoration: _fieldDecoration('Gender'),

                  items: const ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),

                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _gender = value;
                          });
                        },
                ),

                const SizedBox(height: 22),

                // UPDATE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    onPressed: _isSaving ? null : _updateProfile,

                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Account',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
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
    );
  }
}
