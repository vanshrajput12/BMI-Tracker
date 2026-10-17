// pubspec.yaml -> dependencies: google_fonts
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Mostly amber. Red appears only as a slight tint in the top card gradient.
const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _redTint = Color(0xFF3A1815);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _line = Color(0x14FFFFFF);
const _onWhite = Color(0xFF111113);

// TODO: change these to your real details before publishing.
const _supportEmail = 'support@yourapp.com';
const _lastUpdated = 'October 15, 2026';
const _appName = 'this app';

class _Section {
  final String heading;
  final String body;
  const _Section(this.heading, this.body);
}

class _LegalDoc {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_Section> sections;
  const _LegalDoc(this.title, this.subtitle, this.icon, this.sections);
}

const _docs = <_LegalDoc>[
  _LegalDoc('Terms of Use', 'The rules for using the app', Icons.description_outlined, [
    _Section(
      'Using the app',
      'You may use $_appName for your own personal fitness tracking. You must not misuse it, try to break it, or use it for any illegal purpose.',
    ),
    _Section(
      'Your account',
      'You are responsible for your account and for keeping your login details safe. Please give correct information when you sign up.',
    ),
    _Section(
      'Workout plans',
      'The workout plans, calories and tips in the app are general guidance only. Results are different for every person.',
    ),
    _Section(
      'Changes to the app',
      'We may update, change or remove features at any time. We may also update these terms. If we make an important change, we will tell you in the app.',
    ),
    _Section(
      'Ending your account',
      'You can delete your account at any time from Settings > Privacy. We may suspend accounts that break these terms.',
    ),
  ]),
  _LegalDoc('Privacy Policy', 'How we handle your data', Icons.lock_outline_rounded, [
    _Section(
      'What we collect',
      'We collect your email address, your profile details (such as height, weight and goal), your workout progress, your step count and any messages you send to support.',
    ),
    _Section(
      'How we use it',
      'We use your data to run the app, show your progress, adjust your workout plan and reply to your support requests. If you allow it, we also use anonymous usage data and crash reports to improve the app.',
    ),
    _Section(
      'Where it is stored',
      'Your data is stored securely using Google Firebase services. We do not sell your personal data.',
    ),
    _Section(
      'Your choices',
      'You can change what you share in Settings > Privacy and Settings > Preferences. You can delete your account and your data at any time from Settings > Privacy.',
    ),
    _Section(
      'Contact us',
      'If you have questions about your data, email us at $_supportEmail.',
    ),
  ]),
  _LegalDoc(
    'Health Disclaimer',
    'Please read before you exercise',
    Icons.favorite_border_rounded,
    [
      _Section(
        'Not medical advice',
        'The information in this app is for general fitness purposes only. It is not medical advice and does not replace a doctor.',
      ),
      _Section(
        'Talk to a doctor first',
        'Please check with your doctor before starting any exercise or weight loss plan, especially if you have a health condition, are pregnant, are taking medicine, or have not exercised for a long time.',
      ),
      _Section(
        'Listen to your body',
        'Stop exercising right away and get help if you feel dizzy, faint, short of breath, or have chest pain or sharp pain.',
      ),
      _Section(
        'Estimates only',
        'Calories, durations and weight loss targets shown in the app are rough estimates. A safe pace of weight loss is usually about 0.5-1 kg per week.',
      ),
      _Section(
        'Your responsibility',
        'You exercise at your own risk. Use safe equipment, a stable surface and good form.',
      ),
    ],
  ),
];

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

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
          'Legal',
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _hero(t),
          const SizedBox(height: 24),
          _sectionTitle(t, 'Documents'),
          ..._docs.map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _docRow(context, t, d),
            ),
          ),
          const SizedBox(height: 12),
          _sectionTitle(t, 'Open source'),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Open source licenses',
                  style: t.bodyLarge!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This app is built with open source software. See the licenses for each package.',
                  style: t.bodySmall!.copyWith(color: _muted, height: 1.4),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => showLicensePage(
                      context: context,
                      applicationName: 'Fitness app',
                      applicationVersion: '1.0.0',
                    ),
                    icon: const Icon(Icons.code_rounded, size: 20),
                    label: Text(
                      'View licenses',
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'Fitness app  |  Version 1.0.0',
              style: t.bodySmall!.copyWith(color: _muted),
            ),
          ),
        ],
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
            child: const Icon(Icons.gavel_rounded, color: _amber, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legal and policies',
                  style: t.titleMedium!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last updated $_lastUpdated',
                  style: t.bodySmall!.copyWith(color: _muted),
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

  Widget _docRow(BuildContext context, TextTheme t, _LegalDoc d) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _LegalDocScreen(doc: d)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _line),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(d.icon, color: _amber, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      style: t.bodyLarge!.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d.subtitle,
                      style: t.bodySmall!.copyWith(color: _muted),
                    ),
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
}

class _LegalDocScreen extends StatelessWidget {
  final _LegalDoc doc;
  const _LegalDocScreen({required this.doc});

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
        title: Text(
          doc.title,
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _amber.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.update_rounded, color: _amber, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Last updated $_lastUpdated',
                  style: t.bodySmall!.copyWith(color: _amber),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(doc.sections.length, (i) {
            final s = doc.sections[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: t.bodySmall!.copyWith(
                            color: _amber,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s.heading,
                          style: t.bodyLarge!.copyWith(
                            color: _text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.body,
                    style: t.bodyMedium!.copyWith(color: _muted, height: 1.6),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _onWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Got it',
                style: t.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
