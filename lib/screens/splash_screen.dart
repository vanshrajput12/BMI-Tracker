// pubspec.yaml -> dependencies: google_fonts, firebase_auth
// No Lottie or other animation package is needed. Everything is drawn and
// animated with Flutter's own AnimationController and CustomPainter.
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _orange = Color(0xFFFF8A00);
const _muted = Color(0xFF9A98A3);

// Change these to your app's name and tagline.
const _appNameAccent = 'BMI';
const _appNameRest = ' Tracker';
const _tagline = 'Track. Train. Transform.';

const _splashDuration = Duration(milliseconds: 2800);

/// Shows an animated BMI gauge, then opens the right screen:
/// [loggedIn] if the user is signed in, otherwise [loggedOut].
///
/// In main.dart:
///   home: SplashScreen(
///     loggedIn: (_) => const BottomNav(),
///     loggedOut: (_) => const LoginScreen(),
///   ),
class SplashScreen extends StatefulWidget {
  final WidgetBuilder loggedIn;
  final WidgetBuilder loggedOut;

  const SplashScreen({
    super.key,
    required this.loggedIn,
    required this.loggedOut,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: _splashDuration)..forward();

  // 1) the glow behind the gauge fades and grows in
  late final Animation<double> _glow = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
  );

  // 2) the gauge arc is drawn
  late final Animation<double> _arc = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.10, 0.60, curve: Curves.easeInOut),
  );

  // 3) the needle swings up, comes back, and settles in the middle
  late final Animation<double> _needle = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 0.85).chain(CurveTween(curve: Curves.easeOut)),
      weight: 45,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.85, end: 0.45).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.45, end: 0.5).chain(CurveTween(curve: Curves.easeOut)),
      weight: 20,
    ),
  ]).animate(CurvedAnimation(
    parent: _c,
    curve: const Interval(0.10, 0.80),
  ));

  // 4) title and tagline fade and slide up
  late final Animation<double> _title = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tag = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.70, 0.95, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final minimumTime = Future<void>.delayed(_splashDuration);

    // Wait for Firebase to restore the saved login (max 4 seconds).
    User? user;
    try {
      user = await FirebaseAuth.instance
          .authStateChanges()
          .first
          .timeout(const Duration(seconds: 4),
          onTimeout: () => FirebaseAuth.instance.currentUser);
    } catch (_) {
      user = FirebaseAuth.instance.currentUser;
    }

    await minimumTime; // always show the full animation
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, _, __) =>
        user != null ? widget.loggedIn(context) : widget.loggedOut(context),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bg,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 190,
                        child: Stack(
                          children: [
                            // soft orange glow behind the gauge
                            Align(
                              alignment: const Alignment(0, 0.6),
                              child: Transform.scale(
                                scale: 0.6 + 0.4 * _glow.value,
                                child: Opacity(
                                  opacity: _glow.value,
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          _orange.withValues(alpha: 0.22),
                                          _orange.withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CustomPaint(
                              size: const Size(280, 190),
                              painter: _GaugePainter(
                                arc: _arc.value,
                                needle: _needle.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Opacity(
                        opacity: _title.value,
                        child: Transform.translate(
                          offset: Offset(0, 16 * (1 - _title.value)),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                              children: const [
                                TextSpan(
                                    text: _appNameAccent,
                                    style: TextStyle(color: _orange)),
                                TextSpan(
                                    text: _appNameRest,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: _tag.value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - _tag.value)),
                          child: Text(
                            _tagline,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _muted,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // thin loading line at the bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: Center(
                    child: SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _c.value,
                          minHeight: 3,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(_orange),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Draws a half-circle BMI gauge with ticks and a needle.
class _GaugePainter extends CustomPainter {
  final double arc; // 0..1 how much of the arc is drawn
  final double needle; // 0..1 needle position (left to right)

  const _GaugePainter({required this.arc, required this.needle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = size.width * 0.40;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // grey track
    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.08),
    );

    // orange arc, with only a slight red tint at the very end
    if (arc > 0) {
      canvas.drawArc(
        rect,
        math.pi,
        math.pi * arc,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round
          ..shader = const SweepGradient(
            startAngle: math.pi,
            endAngle: 2 * math.pi,
            colors: [Color(0xFFFF9A2E), _orange, Color(0xFFFF5A3C)],
            stops: [0.0, 0.65, 1.0],
          ).createShader(rect),
      );
    }

    // small ticks inside the arc, shown as the arc passes them
    final tick = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.28);
    for (var i = 0; i <= 10; i++) {
      final t = i / 10;
      if (t > arc) break;
      final a = math.pi + math.pi * t;
      final p1 = center + Offset(math.cos(a), math.sin(a)) * (radius - 24);
      final p2 = center + Offset(math.cos(a), math.sin(a)) * (radius - 32);
      canvas.drawLine(p1, p2, tick);
    }

    // needle
    final angle = math.pi + math.pi * needle;
    final tip = center + Offset(math.cos(angle), math.sin(angle)) * (radius - 38);
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = Colors.white,
    );

    // hub
    canvas.drawCircle(center, 12, Paint()..color = _orange);
    canvas.drawCircle(center, 5, Paint()..color = _bg);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.arc != arc || old.needle != needle;
}