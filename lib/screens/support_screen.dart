// pubspec.yaml -> dependencies: google_fonts, firebase_auth, cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Mostly amber. Red appears only as a slight tint in the top card gradient.
const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _redTint = Color(0xFF3A1815);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);

// TODO: change this to your real support email.
const _supportEmail = 'support@yourapp.com';

class _Faq {
  final String q;
  final String a;
  const _Faq(this.q, this.a);
}

const _faqs = <_Faq>[
  _Faq(
    'How do I change my weight loss goal?',
    'Go to Settings > Preferences and choose 1-2 kg, 3-4 kg or 5 kg. Your daily workouts adjust to the new goal.',
  ),
  _Faq(
    'Are the calories exact?',
    'No. Calories shown on the workout screens are rough estimates. Your real burn depends on your weight, pace and effort.',
  ),
  _Faq(
    'Can I skip a day?',
    'Yes, but try not to skip two in a row. If you feel tired, do the light version of the day or take a rest day.',
  ),
  _Faq(
    'How fast should I lose weight?',
    'A safe pace is about 0.5-1 kg per week. Faster loss is hard to keep and can hurt your health.',
  ),
  _Faq(
    'How do I reset my progress?',
    'Contact us with the form below and we will reset it for you.',
  ),
];

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static const _categories = ['Bug', 'Feature idea', 'Account', 'Other'];

  int _category = 0;
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    _toast('Email address copied');
  }

  Future<void> _send() async {
    final message = _controller.text.trim();
    if (message.length < 10) {
      _toast('Please write at least 10 characters.');
      return;
    }
    setState(() => _sending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('support_requests').add({
        'uid': user?.uid,
        'email': user?.email,
        'category': _categories[_category],
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _controller.clear();
      FocusScope.of(context).unfocus();
      _toast('Message sent. We will reply by email.');
    } catch (_) {
      _toast('Could not send. Check your internet and try again.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        title: Text(
          'Support',
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            _hero(t),
            const SizedBox(height: 24),
            _sectionTitle(t, 'Frequently asked'),
            _faqList(t),
            const SizedBox(height: 24),
            _sectionTitle(t, 'Contact us'),
            _emailCard(t),
            const SizedBox(height: 16),
            _messageForm(t),
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
    );
  }

  Widget _hero(TextTheme t) {
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
        border: Border.all(color: _amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: _amber,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help?',
                  style: t.titleMedium!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Read the answers below or send us a message.',
                  style: t.bodySmall!.copyWith(color: _muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(TextTheme t, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _amber,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
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

  Widget _faqList(TextTheme t) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          children: List.generate(_faqs.length, (i) {
            final f = _faqs[i];
            return Column(
              children: [
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 18),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  iconColor: _amber,
                  collapsedIconColor: _muted,
                  expandedAlignment: Alignment.centerLeft,
                  title: Text(
                    f.q,
                    style: t.bodyMedium!.copyWith(
                      color: _text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Text(
                      f.a,
                      style: t.bodySmall!.copyWith(color: _muted, height: 1.5),
                    ),
                  ],
                ),
                if (i != _faqs.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x14FFFFFF),
                    indent: 18,
                    endIndent: 18,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _emailCard(TextTheme t) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _copyEmail,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.mail_outline_rounded,
                color: _amber,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email us',
                    style: t.bodyLarge!.copyWith(
                      color: _text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _supportEmail,
                    style: t.bodySmall!.copyWith(color: _amber),
                  ),
                ],
              ),
            ),
            const Icon(Icons.copy_rounded, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _messageForm(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a message',
            style: t.bodyLarge!.copyWith(
              color: _text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_categories.length, (i) {
              final sel = i == _category;
              return GestureDetector(
                onTap: () => setState(() => _category = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel
                        ? _amber.withOpacity(0.18)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sel ? _amber.withOpacity(0.7) : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    _categories[i],
                    style: t.bodySmall!.copyWith(
                      color: sel ? _amber : _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            maxLines: 5,
            maxLength: 500,
            style: t.bodyMedium!.copyWith(color: _text),
            cursorColor: _amber,
            decoration: InputDecoration(
              hintText: 'Tell us what happened...',
              hintStyle: t.bodyMedium!.copyWith(color: _muted),
              counterStyle: t.bodySmall!.copyWith(color: _muted),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _amber, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _sending ? null : _send,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF111113),
                disabledBackgroundColor: const Color(0xFF2A2A2D),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _sending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF111113),
                      ),
                    )
                  : Text(
                      'Send message',
                      style: t.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
