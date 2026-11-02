
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
  final int upperMin;
  final int lowerMin;
  final int coreMin;
  final int kcalSurplus;
  final String note;
  final String rest;
  final List<Exercise> upper;
  final List<Exercise> lower;
  final List<Exercise> core;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.upperMin,
    required this.lowerMin,
    required this.coreMin,
    required this.kcalSurplus,
    required this.note,
    required this.rest,
    required this.upper,
    required this.lower,
    required this.core,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    upperMin: 12,
    lowerMin: 12,
    coreMin: 6,
    kcalSurplus: 250,
    rest: 'Rest 60 sec between sets',
    note: 'Use light dumbbells. Focus on clean form, not heavy weight.',
    upper: [
      Exercise('Push-ups', '3 sets x 10 reps', Icons.fitness_center),
      Exercise(
        'Dumbbell shoulder press',
        '3 sets x 10 reps',
        Icons.arrow_upward,
      ),
      Exercise('Dumbbell rows', '3 sets x 10 reps', Icons.sync),
    ],
    lower: [
      Exercise(
        'Bodyweight squats',
        '3 sets x 12 reps',
        Icons.arrow_downward,
      ),
      Exercise(
        'Glute bridge',
        '3 sets x 12 reps',
        Icons.airline_seat_flat,
      ),
      Exercise(
        'Lunges',
        '3 sets x 10 reps each leg',
        Icons.directions_walk,
      ),
    ],
    core: [
      Exercise('Plank', '3 sets x 30 sec', Icons.accessibility_new),
      Exercise(
        'Dead bug',
        '3 sets x 10 reps',
        Icons.airline_seat_flat,
      ),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    upperMin: 15,
    lowerMin: 15,
    coreMin: 10,
    kcalSurplus: 400,
    rest: 'Rest 75 sec between sets',
    note:
    'Pick a weight where the last 2 reps feel hard but your form holds.',
    upper: [
      Exercise('Push-ups', '4 sets x 12 reps', Icons.fitness_center),
      Exercise(
        'Dumbbell shoulder press',
        '4 sets x 10 reps',
        Icons.arrow_upward,
      ),
      Exercise(
        'One-arm dumbbell row',
        '4 sets x 10 reps each arm',
        Icons.sync,
      ),
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
    ],
    lower: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise(
        'Romanian deadlift',
        '4 sets x 10 reps',
        Icons.arrow_upward,
      ),
      Exercise(
        'Walking lunges',
        '3 sets x 12 reps each leg',
        Icons.directions_walk,
      ),
      Exercise('Calf raises', '3 sets x 15 reps', Icons.height),
    ],
    core: [
      Exercise('Plank', '3 sets x 45 sec', Icons.accessibility_new),
      Exercise(
        'Weighted crunches',
        '3 sets x 12 reps',
        Icons.fitness_center,
      ),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    upperMin: 18,
    lowerMin: 18,
    coreMin: 9,
    kcalSurplus: 500,
    rest: 'Rest 90 sec between sets',
    note:
    'Heavy sets, fewer reps. Use a spotter or safety bars for big lifts.',
    upper: [
      Exercise('Bench press', '4 sets x 8 reps', Icons.fitness_center),
      Exercise(
        'Overhead press',
        '4 sets x 8 reps',
        Icons.arrow_upward,
      ),
      Exercise('Bent-over rows', '4 sets x 8 reps', Icons.sync),
      Exercise(
        'Pull-ups or lat pulldown',
        '3 sets x 8 reps',
        Icons.expand_less,
      ),
      Exercise('Triceps dips', '3 sets x 10 reps', Icons.arrow_downward),
    ],
    lower: [
      Exercise(
        'Barbell back squat',
        '4 sets x 8 reps',
        Icons.arrow_downward,
      ),
      Exercise('Deadlift', '4 sets x 6 reps', Icons.arrow_upward),
      Exercise(
        'Bulgarian split squat',
        '3 sets x 8 reps each leg',
        Icons.directions_walk,
      ),
      Exercise('Calf raises', '4 sets x 12 reps', Icons.height),
    ],
    core: [
      Exercise(
        'Weighted plank',
        '3 sets x 45 sec',
        Icons.accessibility_new,
      ),
      Exercise(
        'Hanging knee raises',
        '3 sets x 12 reps',
        Icons.airline_seat_flat,
      ),
    ],
  ),
];

class DayGainStrengthScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainStrengthScreen({
    super.key,
    this.day = 2,
    this.title = 'Full Strength Training',
  });

  @override
  State<DayGainStrengthScreen> createState() =>
      _DayGainStrengthScreenState();
}

class _DayGainStrengthScreenState extends State<DayGainStrengthScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total =>
      _plan.upper.length + _plan.lower.length + _plan.core.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  bool get _finished => _completed >= _total;

  void _toggle(String key) {
    setState(() {
      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        _done.add(key);
      }
    });
  }

  void _changeGoal(int index) {
    setState(() {
      _goal = index;
      _done.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
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
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
        children: [
          _header(t),
          const SizedBox(height: 22),

          _goalTitle(t),
          const SizedBox(height: 12),

          _goalSelector(t),
          const SizedBox(height: 20),

          _statsRow(t),
          const SizedBox(height: 24),

          _section(
            t,
            title: 'Warm-up',
            subtitle: '5 min',
            icon: Icons.directions_run,
            child: _description(
              t,
              'Arm circles, shoulder rolls, bodyweight squats and a '
                  'light walk. Warm every joint you are about to load.',
            ),
          ),

          const SizedBox(height: 16),

          _group(
            t,
            title: 'Upper body',
            subtitle: '${_plan.upperMin} min • ${_plan.rest}',
            note: _plan.note,
            prefix: 'upper',
            items: _plan.upper,
            icon: Icons.fitness_center,
          ),

          const SizedBox(height: 16),

          _group(
            t,
            title: 'Lower body',
            subtitle: '${_plan.lowerMin} min • ${_plan.rest}',
            prefix: 'lower',
            items: _plan.lower,
            icon: Icons.directions_walk,
          ),

          const SizedBox(height: 16),

          _group(
            t,
            title: 'Core workout',
            subtitle: '${_plan.coreMin} min • Rest 45 sec',
            prefix: 'core',
            items: _plan.core,
            icon: Icons.accessibility_new,
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            icon: Icons.self_improvement,
            child: _description(
              t,
              'Slow walk, then stretch your chest, shoulders, quads '
                  'and hamstrings. Hold each stretch for 20 seconds.',
            ),
          ),

          const SizedBox(height: 16),

          _tips(t),
          const SizedBox(height: 20),

          _quote(t),
          const SizedBox(height: 10),

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
              top: BorderSide(
                color: _border.withOpacity(0.6),
              ),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _finished
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Day ${widget.day} complete!',
                    ),
                    backgroundColor: _card,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // TODO: Save progress to Firestore here.
                Navigator.pop(context, true);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                disabledBackgroundColor: const Color(0xFF252525),
                foregroundColor: Colors.white,
                disabledForegroundColor: _muted,
                elevation: _finished ? 3 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _finished
                        ? Icons.check_circle_outline
                        : Icons.pending_actions,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    _finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total exercises done',
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _finished ? Colors.white : _muted,
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

  // Progress header
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
                  style: t.bodySmall?.copyWith(color: _muted),
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
                  '$_completed / $_total exercises completed',
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

  // Goal selector heading
  Widget _goalTitle(TextTheme t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your weight gain goal',
          style: t.titleMedium?.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose your target to adjust workout intensity.',
          style: t.bodySmall?.copyWith(color: _muted),
        ),
      ],
    );
  }

  // Goal selector
  Widget _goalSelector(TextTheme t) {
    return Row(
      children: List.generate(_plans.length, (i) {
        final selected = i == _goal;

        return Expanded(
          child: GestureDetector(
            onTap: () => _changeGoal(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: i == _plans.length - 1 ? 0 : 10,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? _orange.withOpacity(0.15)
                    : _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? _orange : _border,
                  width: selected ? 1.4 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _plans[i].label,
                    style: t.titleSmall?.copyWith(
                      color: selected ? _softOrange : _text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _plans[i].intensity,
                    style: t.bodySmall?.copyWith(
                      color: selected ? _orange : _muted,
                      fontSize: 11,
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 6),
                    const Icon(
                      Icons.check_circle,
                      color: _orange,
                      size: 17,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Workout statistics
  Widget _statsRow(TextTheme t) {
    Widget stat(
        IconData icon,
        String value,
        String label,
        ) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            children: [
              Icon(icon, color: _orange, size: 21),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                style: t.titleSmall?.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
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

    final total =
        _plan.upperMin + _plan.lowerMin + _plan.coreMin + 10;

    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total time'),
        const SizedBox(width: 9),
        stat(
          Icons.restaurant_outlined,
          '+${_plan.kcalSurplus}',
          'kcal surplus',
        ),
        const SizedBox(width: 9),
        stat(
          Icons.bolt_outlined,
          _plan.intensity,
          'Intensity',
        ),
      ],
    );
  }

  // Workout group
  Widget _group(
      TextTheme t, {
        required String title,
        required String subtitle,
        String? note,
        required String prefix,
        required List<Exercise> items,
        required IconData icon,
      }) {
    return _section(
      t,
      title: title,
      subtitle: subtitle,
      icon: icon,
      note: note,
      child: Column(
        children: items.map((e) {
          final key = '$prefix:${e.title}';

          return _exerciseTile(
            t,
            e,
            _done.contains(key),
                () => _toggle(key),
          );
        }).toList(),
      ),
    );
  }

  // Common section card
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
        borderRadius: BorderRadius.circular(20),
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
                  color: _orange.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: _orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.titleMedium?.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: t.bodySmall?.copyWith(
                          color: _softOrange,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          if (note != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: _orange.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: _orange,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
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

          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Warm-up and cool-down description
  Widget _description(TextTheme t, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: _orange,
          size: 19,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            description,
            style: t.bodySmall?.copyWith(
              color: _muted,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  // Exercise tile
  Widget _exerciseTile(
      TextTheme t,
      Exercise e,
      bool done,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 9,
        ),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: done
              ? _orange.withOpacity(0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: done
                    ? _success.withOpacity(0.13)
                    : _orange.withOpacity(0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                e.icon,
                color: done ? _success : _orange,
                size: 22,
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
                      decoration: done
                          ? TextDecoration.lineThrough
                          : null,
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

            Icon(
              done
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: done ? _success : Colors.white24,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // Daily tips
  Widget _tips(TextTheme t) {
    const tips = [
      'Eat protein within 1-2 hours after training: eggs, paneer, dal, chicken or curd.',
      'Add 250-500 kcal above your daily need. Banana shake, peanut butter and nuts help.',
      'Add a little weight or one more rep each week. That is what builds muscle.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
      'Never skip form for weight. Lower the load if your technique breaks.',
    ];

    return _section(
      t,
      title: 'Daily tips',
      subtitle: 'Build healthy habits',
      icon: Icons.lightbulb_outline,
      child: Column(
        children: tips.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: _orange,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s,
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

  // Motivational quote
  Widget _quote(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            _orange.withOpacity(0.12),
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
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.13),
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
            child: Text(
              'Strong today, stronger tomorrow.',
              style: t.titleSmall?.copyWith(
                color: _text,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
