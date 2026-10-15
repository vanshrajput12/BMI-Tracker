import 'package:bmi_project/screens/prefrence_screen.dart';
import 'package:bmi_project/screens/privacy_screen.dart';
import 'package:bmi_project/screens/support_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Legal_screen.dart';
import 'auth_pages/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Mostly amber. Red appears only as a slight tint in the profile card gradient.
  static const Color _bg = Color(0xFF121212);
  static const Color _card = Color(0xFF1C1C1E);
  static const Color _amber = Color(0xFFFFB400);
  static const Color _redTint = Color(0xFF3A1815);
  static const Color _text = Color(0xFFEDEAF2);
  static const Color _muted = Color(0xFF9A98A3);
  static const Color _line = Color(0x14FFFFFF);
  static const Color _onWhite = Color(0xFF111113);

  final _auth = FirebaseAuth.instance;

  String get _email => _auth.currentUser?.email ?? '';

  String get _name {
    final display = _auth.currentUser?.displayName;
    if (display != null && display.trim().isNotEmpty) return display.trim();
    if (_email.isNotEmpty) return _email.split('@').first;
    return 'Your account';
  }

  String get _initial => _name.isNotEmpty ? _name[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _text,
            size: 20,
          ),
        ),
        title: Column(
          children: [
            Text(
              'SETTING',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            SizedBox(
              width: 120,
              child: Divider(color: Colors.white, thickness: 1),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(t),
              const SizedBox(height: 28),
              _sectionTitle(t, Icons.settings_outlined, 'General'),
              _generalCard(t),
              const SizedBox(height: 28),
              _sectionTitle(t, Icons.person_outline_rounded, 'Account'),
              _logoutButton(t),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  'Fitness app  |  Version 1.0.0',
                  style: t.bodySmall!.copyWith(color: _muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- pieces ----------

  Widget _profileCard(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2812), _redTint, Color(0xFF1C1C1E)],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _amber.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: _amber.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Text(
              _initial,
              style: t.headlineSmall!.copyWith(
                color: _amber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleMedium!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall!.copyWith(color: _muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(TextTheme t, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _amber),
          const SizedBox(width: 8),
          Text(
            title,
            style: t.titleMedium!.copyWith(
              color: _amber,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generalCard(TextTheme t) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          _settingRow(
            t,
            icon: Icons.tune_rounded,
            title: 'Preferences',
            subtitle: 'Units, goals and reminders',
            onTap: () => _open(PreferencesScreen()),
          ),
          _divider(),
          _settingRow(
            t,
            icon: Icons.lock_outline_rounded,
            title: 'Privacy',
            subtitle: 'Security and data sharing',
            onTap: () => _open(PrivacyScreen()),
          ),
          _divider(),
          _settingRow(
            t,
            icon: Icons.support_agent_rounded,
            title: 'Support',
            subtitle: 'FAQ and contact us',
            onTap: () => _open(SupportScreen()),
          ),
          _divider(),
          _settingRow(
            t,
            icon: Icons.gavel_rounded,
            title: 'Legal',
            subtitle: 'Terms, policies and licenses',
            onTap: () => _open(LegalScreen()),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 1,
    color: _line,
    indent: 74,
    endIndent: 16,
  );

  Widget _settingRow(
    TextTheme t, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _amber.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _amber, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.bodyLarge!.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(subtitle, style: t.bodySmall!.copyWith(color: _muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(TextTheme t) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          'Log Out',
          style: t.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _onWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ---------- actions ----------

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _logout() async {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Log out?',
            style: t.titleMedium!.copyWith(
              color: _text,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: t.bodyMedium!.copyWith(color: _muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: t.titleSmall!.copyWith(color: _muted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Log out',
                style: t.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
