import 'package:bmi_project/screens/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  UserProfile? _profile;

  String _gender = 'Male';
  bool _isLoading = true;
  bool _isSaving = false;

  static const Color _backgroundColor = Color(0xFF111111);
  static const Color _cardColor = Color(0xFF1C1C1C);
  static const Color _fieldColor = Color(0xFF252525);
  static const Color _accentColor = Color(0xFFFF8A00);

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
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (!snapshot.exists || snapshot.data() == null) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      final profile = UserProfile.fromMap(snapshot.id, snapshot.data()!);
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
      debugPrint('Settings load error: $e');

      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Unable to load profile.');
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;

    if (user == null) {
      _showMessage('Please login again.');
      return;
    }

    final name = _nameController.text.trim();
    final weight = double.parse(_weightController.text.trim());
    final height = double.parse(_heightController.text.trim());

    setState(() => _isSaving = true);

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

      await userRef.collection('weightEntries').add({
        'weightKg': weight,
        'date': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showMessage('Profile updated successfully.');

      await _loadProfile();
    } catch (e) {
      debugPrint('Settings update error: $e');

      if (mounted) {
        _showMessage('Unable to update profile.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'U';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      filled: true,
      fillColor: _fieldColor,
      prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 21),
      labelStyle: GoogleFonts.poppins(
        color: Colors.grey.shade500,
        fontSize: 13,
      ),
      suffixStyle: GoogleFonts.poppins(
        color: _accentColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.04)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _accentColor, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _accentColor, size: 18),
        ),
        const SizedBox(width: 11),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _profileCard() {
    if (_profile == null) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withValues(alpha: 0.20),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _profile!.initials,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _profile!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _profile!.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: _accentColor,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: _inputDecoration(
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: _profile?.email ?? '',
            readOnly: true,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: Colors.grey.shade900,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey.shade600,
                size: 21,
              ),
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey.shade700,
                size: 18,
              ),
              labelStyle: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyDataCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: _inputDecoration(
              label: 'Weight',
              suffix: 'kg',
              icon: Icons.monitor_weight_outlined,
            ),
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
          TextFormField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: _inputDecoration(
              label: 'Height',
              suffix: 'cm',
              icon: Icons.height_outlined,
            ),
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
          DropdownButtonFormField<String>(
            initialValue: _gender,
            dropdownColor: _cardColor,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Gender',
              filled: true,
              fillColor: _fieldColor,
              prefixIcon: Icon(
                Icons.wc_outlined,
                color: Colors.grey.shade500,
                size: 21,
              ),
              labelStyle: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _accentColor, width: 1.2),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: _isSaving
                ? null
                : (value) {
                    if (value == null) return;

                    setState(() {
                      _gender = value;
                    });
                  },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
                'PROFILE',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 110, child: Divider(color: Colors.white)),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              child: Image.asset(
                "assets/icon/ic_more.png",
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ],
          actionsPadding: EdgeInsets.only(right: 24, bottom: 10),
        ),
        backgroundColor: _backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(
            color: _accentColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

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
              'PROFILE',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: 110, child: Divider(color: Colors.white)),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
            child: Image.asset(
              "assets/icon/ic_more.png",
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 24, bottom: 10),
      ),
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 10,
            left: 24,
            right: 24,
            bottom: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _profileCard(),
                const SizedBox(height: 20),
                _sectionTitle('Personal Information', Icons.person_outline),
                const SizedBox(height: 14),
                _personalInformationCard(),
                const SizedBox(height: 20),
                _sectionTitle('Body Data', Icons.monitor_weight_outlined),
                const SizedBox(height: 14),
                _bodyDataCard(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      disabledBackgroundColor: _accentColor.withValues(
                        alpha: 0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.black,
                                size: 21,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Save Changes',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    'BMI Tracker • Your health, your progress',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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
// Widget _bodyDataCard() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 6),
//     decoration: BoxDecoration(
//       color: _cardColor,
//       borderRadius: BorderRadius.circular(24),
//       border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
//     ),
//     child: Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: ListTile(
//             leading: Icon(CupertinoIcons.folder_solid, color: Colors.grey),
//             title: Text(
//               "Preferences",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight(400),
//               ),
//             ),
//             trailing: Icon(
//               CupertinoIcons.forward,
//               color: Colors.grey,
//               size: 20,
//             ),
//           ),
//         ),
//         Divider(),
//         SizedBox(
//           width: double.infinity,
//           child: ListTile(
//             leading: Icon(Icons.lock, color: Colors.grey),
//             title: Text(
//               "Privacy",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
//           ),
//         ),
//         Divider(),
//         SizedBox(
//           width: double.infinity,
//           child: ListTile(
//             leading: Icon(Icons.safety_check_rounded, color: Colors.grey),
//             title: Text(
//               "Support",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
//           ),
//         ),
//         Divider(),
//         SizedBox(
//           width: double.infinity,
//           child: ListTile(
//             leading: Icon(
//               CupertinoIcons.collections_solid,
//               color: Colors.grey,
//             ),
//             title: Text(
//               "Legal",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             trailing: Icon(CupertinoIcons.forward, color: Colors.grey),
//           ),
//         ),
//       ],
//     ),
//   );
// }
