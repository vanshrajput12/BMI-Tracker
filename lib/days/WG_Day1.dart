
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _orange = Color(0xFFFF8A24);
const _softOrange = Color(0xFFFFB366);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _border = Color(0xFF303034);
const _success = _orange;

class Exercise {
  final String title;
  final String detail;
  final IconData icon;

  const Exercise(this.title, this.detail, this.icon);
}

class GainPlan {
  final String label;
  final String intensity;
  final int cardioMin;
  final int coreMin;
  final int kcalSurplus;
  final String cardioNote;
  final List<Exercise> cardio;
  final List<Exercise> core;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.cardioMin,
    required this.coreMin,
    required this.kcalSurplus,
    required this.cardioNote,
    required this.cardio,
    required this.core,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 15,
    coreMin: 15,
    kcalSurplus: 250,
    cardioNote:
    'Keep it light. Too much cardio burns the calories you need.',
    cardio: [
      Exercise(
        'Easy walking',
        '15 min, relaxed pace',
        Icons.directions_walk,
      ),
      Exercise(
        'Or cycling',
        '15 min, light resistance',
        Icons.pedal_bike,
      ),
      Exercise(
        'Or swimming',
        '15 min, easy laps',
        Icons.pool,
      ),
    ],
    core: [
      Exercise('Plank', '3 sets x 30 sec', Icons.accessibility_new),
      Exercise('Dead bug', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Leg raises', '3 sets x 10 reps', Icons.sync),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 20,
    coreMin: 20,
    kcalSurplus: 400,
    cardioNote:
    'Short and steady. Save your energy for the core work.',
    cardio: [
      Exercise(
        'Brisk walking',
        '20 min, steady pace',
        Icons.directions_walk,
      ),
      Exercise(
        'Or cycling',
        '20 min, moderate resistance',
        Icons.pedal_bike,
      ),
      Exercise(
        'Or swimming',
        '20 min, easy laps',
        Icons.pool,
      ),
    ],
    core: [
      Exercise(
        'Weighted crunches',
        '3 sets x 12 reps',
        Icons.fitness_center,
      ),
      Exercise('Plank', '3 sets x 45 sec', Icons.accessibility_new),
      Exercise('Leg raises', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise(
        'Weighted Russian twists',
        '3 sets x 15 reps',
        Icons.rotate_right,
      ),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 20,
    coreMin: 30,
    kcalSurplus: 500,
    cardioNote:
    'Light only. Your main work today is the heavy core sets.',
    cardio: [
      Exercise(
        'Brisk walking',
        '20 min, steady pace',
        Icons.directions_walk,
      ),
      Exercise(
        'Or cycling',
        '20 min, light to moderate',
        Icons.pedal_bike,
      ),
      Exercise(
        'Or swimming',
        '20 min, easy laps',
        Icons.pool,
      ),
    ],
    core: [
      Exercise(
        'Weighted plank',
        '4 sets x 45 sec',
        Icons.accessibility_new,
      ),
      Exercise(
        'Weighted Russian twists',
        '4 sets x 16 reps',
        Icons.rotate_right,
      ),
      Exercise(
        'Hanging knee raises',
        '4 sets x 12 reps',
        Icons.airline_seat_flat,
      ),
      Exercise(
        'Ab wheel rollouts',
        '3 sets x 10 reps',
        Icons.sync,
      ),
      Exercise(
        'Weighted sit-ups',
        '4 sets x 12 reps',
        Icons.fitness_center,
      ),
    ],
  ),
];

class DayGainWorkoutScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainWorkoutScreen({
    super.key,
    this.day = 1,
    this.title = 'Cardio + Core',
  });

  @override
  State<DayGainWorkoutScreen> createState() =>
      _DayGainWorkoutScreenState();
}

class _DayGainWorkoutScreenState extends State<DayGainWorkoutScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total => 1 + _plan.core.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleCardio(String name) {
    setState(() {
      final key = 'cardio:$name';

      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        _done.removeWhere((e) => e.startsWith('cardio:'));
        _done.add(key);
      }
    });
  }

  void _toggleCore(String name) {
    setState(() {
      final key = 'core:$name';

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

    final finished = _completed >= _total;

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
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _header(t),
          const SizedBox(height: 26),

          _sectionHeading(
            t,
            'Your weight gain goal',
            '',
          ),
          const SizedBox(height: 12),

          _goalSelector(t),
          const SizedBox(height: 22),

          _statsRow(t),
          const SizedBox(height: 28),

          _section(
            t,
            title: 'Warm-up',
            subtitle: '5 min',
            icon: Icons.wb_sunny_outlined,
            child: _descriptionTile(
              t,
              'Arm circles, hip rotations and a slow walk. Get your heart rate up gently before you start.',
              Icons.directions_walk,
            ),
          ),

          const SizedBox(height: 18),

          _section(
            t,
            title: 'Cardio',
            subtitle: '${_plan.cardioMin} min • Pick one',
            icon: Icons.directions_run,
            note: _plan.cardioNote,
            child: Column(
              children: _plan.cardio.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('cardio:${e.title}'),
                      () => _toggleCardio(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 18),

          _section(
            t,
            title: 'Core workout',
            subtitle:
            '${_plan.coreMin} min • Rest 45 sec between sets',
            icon: Icons.fitness_center,
            child: Column(
              children: _plan.core.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('core:${e.title}'),
                      () => _toggleCore(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 18),

          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            icon: Icons.self_improvement,
            child: _descriptionTile(
              t,
              'Slow walk, then stretch your hamstrings, hips and lower back. Hold each stretch for 20 seconds.',
              Icons.spa_outlined,
            ),
          ),

          const SizedBox(height: 18),

          _tips(t),
          const SizedBox(height: 18),

          _quote(t),
          const SizedBox(height: 22),

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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: _bg,
            border: Border(
              top: BorderSide(
                color: _border.withOpacity(0.6),
              ),
            ),
          ),
          child: SizedBox(
            height: 64,
            child: ElevatedButton(
              onPressed: finished
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
                disabledBackgroundColor: const Color(0xFF292929),
                foregroundColor: Colors.white,
                disabledForegroundColor: _muted,
                elevation: finished ? 3 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (finished) ...[
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                  ],
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total activities done',
                    style: t.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  // HEADER

  Widget _header(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF302116),
            Color(0xFF211D19),
            Color(0xFF1C1C1E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _orange.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      style: t.headlineSmall!.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Build strength and gain healthy weight.',
                      style: t.bodySmall!.copyWith(
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white12,
                        valueColor:
                        const AlwaysStoppedAnimation(_orange),
                      ),
                    ),
                    Text(
                      '${(_progress * 100).round()}%',
                      style: t.titleSmall!.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Today's progress",
            style: t.bodySmall!.copyWith(color: _muted),
          ),
          const SizedBox(height: 10),
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
    );
  }

  // SECTION HEADING

  Widget _sectionHeading(
      TextTheme t,
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.titleMedium!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: t.bodySmall!.copyWith(color: _muted),
          ),
        ],
      ],
    );
  }

  // GOAL SELECTOR

  Widget _goalSelector(TextTheme t) {
    return Row(
      children: List.generate(_plans.length, (i) {
        final selected = i == _goal;

        return Expanded(
          child: GestureDetector(
            onTap: () => _changeGoal(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: EdgeInsets.only(
                right: i == _plans.length - 1 ? 0 : 10,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected
                    ? _orange.withOpacity(0.13)
                    : _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? _orange : _border,
                  width: selected ? 1.3 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _plans[i].label,
                    style: t.titleSmall!.copyWith(
                      color: selected ? _softOrange : _text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _plans[i].intensity,
                    style: t.bodySmall!.copyWith(
                      color: selected ? _softOrange : _muted,
                      fontSize: 11,
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

  // STATS

  Widget _statsRow(TextTheme t) {
    Widget stat(
        IconData icon,
        String value,
        String label,
        ) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
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
              const SizedBox(height: 9),
              Text(
                value,
                style: t.titleMedium!.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: t.bodySmall!.copyWith(
                  color: _muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final total = _plan.cardioMin + _plan.coreMin + 10;

    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total time'),
        const SizedBox(width: 10),
        stat(
          Icons.restaurant_outlined,
          '+${_plan.kcalSurplus}',
          'kcal surplus',
        ),
        const SizedBox(width: 10),
        stat(Icons.bolt_outlined, _plan.intensity, 'Intensity'),
      ],
    );
  }

  // SECTION CARD

  Widget _section(
      TextTheme t, {
        required String title,
        required String subtitle,
        String? note,
        required Widget child,
        required IconData icon,
      }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: _orange,
                  size: 19,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.titleSmall!.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: t.bodySmall!.copyWith(
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
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.035),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: _muted,
                    size: 17,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      note,
                      style: t.bodySmall!.copyWith(
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

  // DESCRIPTION TILE

  Widget _descriptionTile(
      TextTheme t,
      String description,
      IconData icon,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _orange.withOpacity(0.11),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: _orange,
            size: 21,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            description,
            style: t.bodySmall!.copyWith(
              color: _muted,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // EXERCISE TILE

  Widget _exerciseTile(
      TextTheme t,
      Exercise e,
      bool done,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: done ? _orange.withOpacity(0.09) : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: done
                    ? _orange.withOpacity(0.15)
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
                    style: t.bodyMedium!.copyWith(
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
                    style: t.bodySmall!.copyWith(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                done
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                key: ValueKey(done),
                color: done ? _orange : Colors.white24,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DAILY TIPS

  Widget _tips(TextTheme t) {
    const tips = [
      'Drink 2-3 litres of water today.',
      'Eat about 250-500 kcal above your daily need.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
      'A safe pace is about 0.25-0.5 kg per week.',
    ];

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
              const Icon(
                Icons.lightbulb_outline,
                color: _orange,
                size: 21,
              ),
              const SizedBox(width: 10),
              Text(
                'Daily tips',
                style: t.titleMedium!.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map(
                (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: _orange,
                    size: 17,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      s,
                      style: t.bodySmall!.copyWith(
                        color: _muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MOTIVATIONAL QUOTE

  Widget _quote(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFF201D19),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _orange.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
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
              "Don't run from your dream, chase the dream.",
              style: t.bodyMedium!.copyWith(
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
