// pubspec.yaml -> dependencies: google_fonts, firebase_auth (you already use it)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Mostly amber. Red appears only as a slight tint in card gradients.
const _bg = Color(0xFF121212);
const _surface = Color(0xFF1C1C1E);
const _line = Color(0x14FFFFFF);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _amber = Color(0xFFFFB400);
const _onAmber = Color(0xFF1A1205);
const _redTint = Color(0xFF3A1815);

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _usageData = true;
  bool _crashReports = true;
  bool _personalTips = true;
  bool _busy = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  void _toast(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  // ---------- actions ----------

  Future<void> _sendPasswordReset() async {
    final email = _user?.email;
    if (email == null) {
      _toast('No email is linked to this account.');
      return;
    }
    setState(() => _busy = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _toast('Password reset link sent to $email');
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Could not send the reset email.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete() async {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Delete your account?',
            style: t.titleMedium!
                .copyWith(color: _text, fontWeight: FontWeight.w600)),
        content: Text(
          'This permanently deletes your account and your workout progress. You cannot undo this.',
          style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: t.titleSmall!.copyWith(color: _text)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete',
                style: t.titleSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      // TODO: delete the user's Firestore data first (for example users/{uid}).
      await _user?.delete();
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _toast('Please log out and log in again, then try deleting.');
      } else {
        _toast(e.message ?? 'Could not delete the account.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: _text),
        title: Text('Privacy',
            style: t.titleLarge!
                .copyWith(color: _text, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              _banner(t),
              const SizedBox(height: 24),
              _sectionTitle(t, Icons.lock_outline_rounded, 'Security'),
              _card([
                _navRow(t, Icons.mail_outline_rounded, 'Signed in as',
                    _user?.email ?? 'Not available',
                    showChevron: false),
                _divider(),
                _navRow(t, Icons.key_rounded, 'Change password',
                    'Send reset link',
                    onTap: _sendPasswordReset),
              ]),
              const SizedBox(height: 24),
              _sectionTitle(t, Icons.shield_outlined, 'Data sharing'),
              _card([
                _switchRow(
                    t,
                    'Usage data',
                    'Anonymous stats that help us improve the app',
                    _usageData,
                        (v) => setState(() => _usageData = v)),
                _divider(),
                _switchRow(
                    t,
                    'Crash reports',
                    'Send error logs when the app crashes',
                    _crashReports,
                        (v) => setState(() => _crashReports = v)),
                _divider(),
                _switchRow(
                    t,
                    'Personalised tips',
                    'Use your goal and progress to suggest tips',
                    _personalTips,
                        (v) => setState(() => _personalTips = v)),
              ]),
              const SizedBox(height: 24),
              _sectionTitle(t, Icons.warning_amber_rounded, 'Danger zone'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_redTint, Color(0xFF1C1C1E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _amber.withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delete account',
                        style: t.bodyLarge!.copyWith(
                            color: _text, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                        'Permanently remove your account and all workout progress.',
                        style: t.bodySmall!
                            .copyWith(color: _muted, height: 1.4)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: _busy ? null : _confirmDelete,
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 20),
                        label: Text('Delete my account',
                            style: t.titleSmall!
                                .copyWith(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.6)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_busy)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                    child: CircularProgressIndicator(color: _amber)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _banner(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2812), _redTint, Color(0xFF1C1C1E)],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _amber.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _amber.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.verified_user_outlined,
                color: _amber, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your data stays yours',
                    style: t.titleSmall!.copyWith(
                        color: _text, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                    'Choose what you share and manage your account security here.',
                    style: t.bodySmall!.copyWith(color: _muted, height: 1.4)),
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
          Text(title,
              style: t.titleMedium!
                  .copyWith(color: _amber, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => const Divider(
      height: 1, thickness: 1, color: _line, indent: 16, endIndent: 16);

  Widget _switchRow(TextTheme t, String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyLarge!.copyWith(color: _text)),
                const SizedBox(height: 2),
                Text(subtitle, style: t.bodySmall!.copyWith(color: _muted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A1A1C),
            activeTrackColor: Colors.white,
            inactiveThumbColor: _muted,
            inactiveTrackColor: Colors.white12,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _navRow(TextTheme t, IconData icon, String title, String value,
      {VoidCallback? onTap, bool showChevron = true}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: _muted, size: 22),
            const SizedBox(width: 12),
            Text(title, style: t.bodyLarge!.copyWith(color: _text)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMedium!.copyWith(color: _amber)),
            ),
            if (showChevron) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ],
        ),
      ),
    );
  }
}