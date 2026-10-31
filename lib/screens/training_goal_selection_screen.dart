// pubspec.yaml -> dependencies: google_fonts, shared_preferences, firebase_auth
import 'package:bmi_project/screens/trainingScheduleScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1C);
const _orange = Color(0xFFFF8A00);
const _amber = Color(0xFFFFB400);
const _text = Colors.white;
const _muted = Color(0xFF9A98A3);
const _redTint = Color(0xFF3A1815);

enum TrainingGoal { loss, gain }

class _GoalInfo {
  final TrainingGoal goal;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> tags;
  final List<Color> gradient;
  const _GoalInfo({
    required this.goal,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tags,
    required this.gradient,
  });
}

const _goals = <_GoalInfo>[
  _GoalInfo(
    goal: TrainingGoal.loss,
    title: 'Weight Loss',
    subtitle: 'Burn fat and get lighter with a 7-day plan of cardio, HIIT and core.',
    icon: Icons.trending_down_rounded,
    tags: ['Cardio', 'HIIT', 'Core', '1-5 kg goals'],
    // a slight red tint in the gradient
    gradient: [Color(0xFF3A2812), _redTint, Color(0xFF1C1C1C)],
  ),
  _GoalInfo(
    goal: TrainingGoal.gain,
    title: 'Weight Gain',
    subtitle: 'Build muscle and healthy weight with strength-focused training.',
    icon: Icons.trending_up_rounded,
    tags: ['Strength', 'Muscle', 'Healthy calories'],
    gradient: [Color(0xFF3A2C12), Color(0xFF2A2012), Color(0xFF1C1C1C)],
  ),
];

/// Lets the user choose between weight loss and weight gain training.
///
/// Pass [bmi] (optional) to show a suggestion:
///   under 18.5 -> weight gain, 25 or more -> weight loss.
class TrainingGoalScreen extends StatefulWidget {
  final double? bmi;
  const TrainingGoalScreen({super.key, this.bmi});

  /// The goal the user chose last time (null if none yet).
  static Future<TrainingGoal?> savedGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefsKey);
    return switch (value) {
      'loss' => TrainingGoal.loss,
      'gain' => TrainingGoal.gain,
      _ => null,
    };
  }

  static String get _prefsKey =>
      'training_goal_${FirebaseAuth.instance.currentUser?.uid ?? 'guest'}';

  @override
  State<TrainingGoalScreen> createState() => _TrainingGoalScreenState();
}

class _TrainingGoalScreenState extends State<TrainingGoalScreen> {
  TrainingGoal? _selected;

  @override
  void initState() {
    super.initState();
    TrainingGoalScreen.savedGoal().then((g) {
      if (mounted && g != null) setState(() => _selected = g);
    });
  }

  // ---------- BMI helpers ----------

  String? get _bmiCategory {
    final b = widget.bmi;
    if (b == null) return null;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  TrainingGoal? get _recommended {
    final b = widget.bmi;
    if (b == null) return null;
    if (b < 18.5) return TrainingGoal.gain;
    if (b >= 25) return TrainingGoal.loss;
    return null;
  }

  // ---------- actions ----------

  Future<void> _continue() async {
    final goal = _selected;
    if (goal == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        TrainingGoalScreen._prefsKey, goal == TrainingGoal.loss ? 'loss' : 'gain');
    if (!mounted) return;

    if (goal == TrainingGoal.loss) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TrainingScheduleScreen()),
      );
    } else {
      // TODO: replace with the weight gain schedule screen when it is ready.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight gain plan is coming soon.')),
      );
    }
  }

  // ---------- screen ----------

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
        iconTheme: const IconThemeData(color: _text),
        title: Column(
          children: [
            Text('CHOOSE YOUR GOAL',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _orange)),
            const SizedBox(
                width: 250, child: Divider(color: Colors.white, height: 8)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Text('What do you want to achieve?',
              style: t.titleLarge!
                  .copyWith(color: _text, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('We will build your training plan around your goal.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.4)),
          if (widget.bmi != null) ...[
            const SizedBox(height: 18),
            _bmiStrip(t),
          ],
          const SizedBox(height: 22),
          ..._goals.map((g) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _goalCard(t, g),
          )),
          const SizedBox(height: 4),
          Center(
            child: Text('You can change this later.',
                style: t.bodySmall!.copyWith(color: _muted)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: _selected == null ? null : _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF111113),
                disabledBackgroundColor: const Color(0xFF2A2A2D),
                disabledForegroundColor: _muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      _selected == null
                          ? 'Select a goal'
                          : 'Continue with ${_selected == TrainingGoal.loss ? 'Weight Loss' : 'Weight Gain'}',
                      style: t.titleMedium!
                          .copyWith(fontWeight: FontWeight.w700)),
                  if (_selected != null) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 22),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- pieces ----------

  Widget _bmiStrip(TextTheme t) {
    final rec = _recommended;
    final suggestion = rec == null
        ? 'Choose the goal that fits you best.'
        : 'We suggest ${rec == TrainingGoal.loss ? 'Weight Loss' : 'Weight Gain'}. You can still pick either.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.monitor_weight_outlined,
                color: _orange, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Your BMI  ',
                        style: t.bodySmall!.copyWith(color: _muted)),
                    Text(widget.bmi!.toStringAsFixed(1),
                        style: t.titleSmall!.copyWith(
                            color: _text, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text(_bmiCategory ?? '',
                        style: t.bodySmall!.copyWith(
                            color: _orange, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(suggestion,
                    style: t.bodySmall!.copyWith(color: _muted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(TextTheme t, _GoalInfo g) {
    final selected = _selected == g.goal;
    final recommended = _recommended == g.goal;

    return GestureDetector(
      onTap: () => setState(() => _selected = g.goal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: g.gradient,
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: selected
                ? _orange
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
                color: _orange.withValues(alpha: 0.22),
                blurRadius: 22,
                spreadRadius: 0),
          ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(g.icon, color: _orange, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title,
                          style: t.titleLarge!.copyWith(
                              color: _text, fontWeight: FontWeight.w700)),
                      if (recommended) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: _amber.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Suggested for you',
                              style: t.labelSmall!.copyWith(
                                  color: _amber,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? _orange : Colors.transparent,
                    border: Border.all(
                        color: selected ? _orange : Colors.white24, width: 2),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                      color: Color(0xFF1A1205), size: 20)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(g.subtitle,
                style: t.bodyMedium!.copyWith(color: _muted, height: 1.5)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: g.tags
                  .map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tag,
                    style: t.bodySmall!.copyWith(
                        color: _text.withValues(alpha: 0.85))),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}