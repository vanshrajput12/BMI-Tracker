
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _orange = Color(0xFFFF8A24);
const _softOrange = Color(0xFFFFB366);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _border = Color(0xFF303034);
const _success = Color(0xFF55C98A);

class Exercise {
  final String title;
  final String detail;
  final IconData icon;

  const Exercise(this.title, this.detail, this.icon);
}

class GainPlan {
  final String label;
  final String intensity;
  final int armsMin;
  final int legsMin;
  final int kcalSurplus;
  final String rest;
  final String armsNote;
  final String legsNote;
  final List<Exercise> arms;
  final List<Exercise> legs;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.armsMin,
    required this.legsMin,
    required this.kcalSurplus,
    required this.rest,
    required this.armsNote,
    required this.legsNote,
    required this.arms,
    required this.legs,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    armsMin: 15,
    legsMin: 15,
    kcalSurplus: 250,
    rest: 'Rest 60 sec between sets',
    armsNote: 'Light dumbbells. Lift for 2 sec, lower for 3 sec.',
    legsNote:
    'Bodyweight or light dumbbells. Keep your knees in line with your toes.',
    arms: [
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Triceps kickbacks', '3 sets x 12 reps', Icons.arrow_back),
      Exercise('Hammer curls', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Bench dips', '3 sets x 8 reps', Icons.arrow_downward),
    ],
    legs: [
      Exercise('Bodyweight squats', '3 sets x 15 reps', Icons.arrow_downward),
      Exercise('Reverse lunges', '3 sets x 10 reps each leg',
          Icons.directions_walk),
      Exercise('Glute bridge', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Calf raises', '3 sets x 15 reps', Icons.height),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    armsMin: 18,
    legsMin: 20,
    kcalSurplus: 400,
    rest: 'Rest 75 sec between sets',
    armsNote:
    'Moderate weight. The last 2 reps of each set should feel hard.',
    legsNote: 'Go deep on squats if your knees and hips allow it.',
    arms: [
      Exercise('Barbell or dumbbell curls', '4 sets x 10 reps',
          Icons.fitness_center),
      Exercise('Overhead triceps extension', '4 sets x 10 reps',
          Icons.arrow_upward),
      Exercise('Hammer curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Close-grip push-ups', '3 sets x 10 reps',
          Icons.accessibility_new),
      Exercise('Lateral raises', '3 sets x 12 reps', Icons.open_with),
    ],
    legs: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Romanian deadlift', '4 sets x 10 reps', Icons.arrow_upward),
      Exercise('Walking lunges', '3 sets x 12 reps each leg',
          Icons.directions_walk),
      Exercise('Step-ups', '3 sets x 10 reps each leg', Icons.stairs),
      Exercise('Calf raises', '4 sets x 15 reps', Icons.height),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    armsMin: 20,
    legsMin: 25,
    kcalSurplus: 500,
    rest: 'Rest 90 sec between sets',
    armsNote: 'Heavier weights, strict form. No swinging the body.',
    legsNote: 'Heavy sets. Use a spotter or safety bars for squats.',
    arms: [
      Exercise('Barbell curls', '4 sets x 8 reps', Icons.fitness_center),
      Exercise('Skull crushers', '4 sets x 8 reps', Icons.arrow_upward),
      Exercise('Incline dumbbell curls', '3 sets x 10 reps',
          Icons.fitness_center),
      Exercise('Triceps dips', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Hammer curls', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Lateral raises', '3 sets x 12 reps', Icons.open_with),
    ],
    legs: [
      Exercise('Barbell back squat', '5 sets x 6 reps', Icons.arrow_downward),
      Exercise('Romanian deadlift', '4 sets x 8 reps', Icons.arrow_upward),
      Exercise('Leg press', '4 sets x 10 reps',
          Icons.airline_seat_legroom_extra),
      Exercise('Bulgarian split squat', '3 sets x 8 reps each leg',
          Icons.directions_walk),
      Exercise('Standing calf raises', '4 sets x 12 reps', Icons.height),
    ],
  ),
];

class DayGainStrengthTrainingScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainStrengthTrainingScreen({
    super.key,
    this.day = 5,
    this.title = 'Strength Training',
  });

  @override
  State<DayGainStrengthTrainingScreen> createState() =>
      _DayGainStrengthTrainingScreenState();
}

class _DayGainStrengthTrainingScreenState
    extends State<DayGainStrengthTrainingScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total => _plan.arms.length + _plan.legs.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggle(String key) {
    setState(() {
      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        _done.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    final finished = _completed >= _total;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: const BackButton(color: _text),
        title: Text(
          'Day ${widget.day}',
          style: t.titleLarge?.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 125),
        children: [
          _header(t),
          const SizedBox(height: 24),

          _sectionHeading(t, 'Your weight gain goal',
              'Choose your workout level'),
          const SizedBox(height: 12),
          _goalSelector(t),

          const SizedBox(height: 22),
          _statsRow(t),

          const SizedBox(height: 26),

          _section(
            t,
            title: 'Warm-up',
            subtitle: '5 min',
            icon: Icons.local_fire_department_outlined,
            child: Text(
              'Arm circles, wrist rolls, bodyweight squats and leg swings. Do 1 light set of your first exercise before you load it.',
              style: t.bodyMedium?.copyWith(
                color: _muted,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Arms workout',
            subtitle: '${_plan.armsMin} min',
            icon: Icons.fitness_center,
            note: _plan.armsNote,
            child: Column(
              children: _plan.arms.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('arms:${e.title}'),
                      () => _toggle('arms:${e.title}'),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Legs workout',
            subtitle: '${_plan.legsMin} min',
            icon: Icons.directions_walk,
            note: _plan.legsNote,
            child: Column(
              children: _plan.legs.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('legs:${e.title}'),
                      () => _toggle('legs:${e.title}'),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            icon: Icons.self_improvement,
            child: Text(
              'Slow walk, then stretch your biceps, triceps, quads, hamstrings and calves. Hold each stretch for 20 seconds.',
              style: t.bodyMedium?.copyWith(
                color: _muted,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 16),
          _tips(t),
          const SizedBox(height: 18),
          _quote(t),
          const SizedBox(height: 20),

          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset(
                'assets/images/workGym.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          decoration: BoxDecoration(
            color: _bg,
            border: Border(
              top: BorderSide(color: _border.withValues(alpha: 0.7)),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: finished
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Day ${widget.day} complete!'),
                    backgroundColor: _card,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // TODO: Save workout progress to Firestore.
                Navigator.pop(context, true);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                disabledBackgroundColor: _card,
                foregroundColor: Colors.black,
                disabledForegroundColor: _muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    finished ? Icons.check_circle_outline : Icons.lock_outline,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total exercises done',
                    style: t.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3A2417),
            Color(0xFF211B18),
            _card,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _orange.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEIGHT GAIN',
                  style: t.labelSmall?.copyWith(
                    color: _softOrange,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  widget.title,
                  style: t.headlineSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Today's progress",
                  style: t.bodySmall?.copyWith(
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 13),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(_orange),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  '$_completed / $_total activities completed',
                  style: t.bodySmall?.copyWith(
                    color: _softOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(_orange),
                  ),
                ),
                Text(
                  '${(_progress * 100).round()}%',
                  style: t.titleSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(TextTheme t, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.titleMedium?.copyWith(
            color: _text,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: t.bodySmall?.copyWith(color: _muted),
        ),
      ],
    );
  }

  Widget _goalSelector(TextTheme t) {
    return Row(
      children: List.generate(_plans.length, (i) {
        final selected = i == _goal;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _goal = i;
                _done.clear();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: i == _plans.length - 1 ? 0 : 10,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected ? _orange : _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? _orange : _border,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _plans[i].label,
                    style: t.titleSmall?.copyWith(
                      color: selected ? Colors.black : _text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _plans[i].intensity,
                    style: t.bodySmall?.copyWith(
                      color: selected
                          ? Colors.black.withValues(alpha: 0.65)
                          : _muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _statsRow(TextTheme t) {
    Widget stat(IconData icon, String value, String label) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Icon(icon, color: _orange, size: 21),
              const SizedBox(height: 8),
              Text(
                value,
                textAlign: TextAlign.center,
                style: t.titleSmall?.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(
                  color: _muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final total = _plan.armsMin + _plan.legsMin + 10;

    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total time'),
        const SizedBox(width: 9),
        stat(Icons.restaurant_outlined, '+${_plan.kcalSurplus}', 'Kcal surplus'),
        const SizedBox(width: 9),
        stat(Icons.bolt_outlined, _plan.intensity, 'Level'),
      ],
    );
  }

  Widget _section(
      TextTheme t, {
        required String title,
        required String subtitle,
        required IconData icon,
        String? note,
        required Widget child,
      }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _orange, size: 20),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: t.titleMedium?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (subtitle.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle,
                    style: t.labelSmall?.copyWith(
                      color: _softOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: _softOrange,
                    size: 18,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      note,
                      style: t.bodySmall?.copyWith(
                        color: _muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _exerciseTile(
      TextTheme t,
      Exercise e,
      bool done,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: done
                    ? _orange.withValues(alpha: 0.14)
                    : const Color(0xFF29292C),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                e.icon,
                color: done ? _orange : _text,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: t.bodyMedium?.copyWith(
                      color: done ? _muted : _text,
                      fontWeight: FontWeight.w600,
                      decoration:
                      done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    e.detail,
                    style: t.bodySmall?.copyWith(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: done ? _orange : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: done ? _orange : Colors.white24,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(
                Icons.check,
                color: Colors.black,
                size: 16,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tips(TextTheme t) {
    const tips = [
      'Eat protein within 1-2 hours after training: eggs, paneer, dal, chicken or curd.',
      'Add 250-500 kcal above your daily need. Banana shake, peanut butter and nuts help.',
      'Try to add a little weight or one more rep than last week.',
      'Do not skip leg day. Big muscles help your whole body grow.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
    ];

    return _section(
      t,
      title: 'Daily tips',
      subtitle: 'Stay consistent',
      icon: Icons.tips_and_updates_outlined,
      child: Column(
        children: tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: _orange,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tip,
                    style: t.bodySmall?.copyWith(
                      color: _muted,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _quote(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _orange.withValues(alpha: 0.13),
            _card,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _orange.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: _orange,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Small gains every week add up.',
                  style: t.titleSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep showing up. Keep getting stronger.',
                  style: t.bodySmall?.copyWith(color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
