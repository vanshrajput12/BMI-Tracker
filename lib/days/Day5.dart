import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _orange = Color(0xFFFF8A24);
const _softOrange = Color(0xFFFFB366);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _border = Color(0xFF303034);

class _Exercise {
  final String title;
  final String detail;
  final IconData icon;

  const _Exercise(this.title, this.detail, this.icon);
}

class _GoalPlan {
  final String label;
  final String intensity;
  final int warmupMin;
  final int strengthMin;
  final int kcal;
  final String strengthNote;
  final List<_Exercise> warmup;
  final List<_Exercise> strength;

  const _GoalPlan({
    required this.label,
    required this.intensity,
    required this.warmupMin,
    required this.strengthMin,
    required this.kcal,
    required this.strengthNote,
    required this.warmup,
    required this.strength,
  });
}

const _plans = <_GoalPlan>[
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    warmupMin: 5,
    strengthMin: 30,
    kcal: 220,
    strengthNote:
    'Light to moderate dumbbells. Rest 45-60 sec between sets.',
    warmup: [
      _Exercise(
        'Light jumping',
        '5 min, easy skipping or small hops',
        Icons.arrow_upward,
      ),
      _Exercise(
        'Or walking',
        '5 min, brisk pace',
        Icons.directions_walk,
      ),
    ],
    strength: [
      _Exercise('Chest press', '3 sets x 12 reps', Icons.fitness_center),
      _Exercise(
        'Deadlift',
        '3 sets x 12 reps',
        Icons.vertical_align_bottom,
      ),
      _Exercise(
        'Step-ups',
        '3 sets x 12 reps each leg',
        Icons.stairs_outlined,
      ),
      _Exercise(
        'Dumbbell bicep curls',
        '3 sets x 12 reps',
        Icons.fitness_center,
      ),
      _Exercise(
        'Triceps dips',
        '3 sets x 12 reps',
        Icons.event_seat_outlined,
      ),
    ],
  ),
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    warmupMin: 8,
    strengthMin: 35,
    kcal: 320,
    strengthNote: 'Moderate dumbbells. Rest 45 sec between sets.',
    warmup: [
      _Exercise(
        'Light jumping',
        '8 min, skipping or jumping jacks',
        Icons.arrow_upward,
      ),
      _Exercise(
        'Or walking',
        '8 min, brisk pace',
        Icons.directions_walk,
      ),
    ],
    strength: [
      _Exercise('Chest press', '3 sets x 15 reps', Icons.fitness_center),
      _Exercise(
        'Deadlift',
        '3 sets x 15 reps',
        Icons.vertical_align_bottom,
      ),
      _Exercise(
        'Step-ups',
        '3 sets x 15 reps each leg',
        Icons.stairs_outlined,
      ),
      _Exercise(
        'Dumbbell bicep curls',
        '3 sets x 15 reps',
        Icons.fitness_center,
      ),
      _Exercise(
        'Triceps dips',
        '3 sets x 15 reps',
        Icons.event_seat_outlined,
      ),
    ],
  ),
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    warmupMin: 10,
    strengthMin: 40,
    kcal: 440,
    strengthNote: 'Heavier dumbbells. Rest 30-45 sec between sets.',
    warmup: [
      _Exercise(
        'Light jumping',
        '10 min, skipping and jumping jacks',
        Icons.arrow_upward,
      ),
      _Exercise(
        'Or brisk walk / jog',
        '10 min, build up slowly',
        Icons.directions_run,
      ),
    ],
    strength: [
      _Exercise('Chest press', '4 sets x 15 reps', Icons.fitness_center),
      _Exercise(
        'Deadlift',
        '4 sets x 15 reps',
        Icons.vertical_align_bottom,
      ),
      _Exercise(
        'Step-ups',
        '4 sets x 15 reps each leg',
        Icons.stairs_outlined,
      ),
      _Exercise(
        'Dumbbell bicep curls',
        '4 sets x 15 reps',
        Icons.fitness_center,
      ),
      _Exercise(
        'Triceps dips',
        '4 sets x 15 reps',
        Icons.event_seat_outlined,
      ),
      _Exercise(
        'Plank',
        '3 sets x 45 sec',
        Icons.timer_outlined,
      ),
    ],
  ),
];

class DayStrengthTrainingScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayStrengthTrainingScreen({
    super.key,
    this.day = 5,
    this.title = 'Strength Training',
  });

  @override
  State<DayStrengthTrainingScreen> createState() =>
      _DayStrengthTrainingScreenState();
}

class _DayStrengthTrainingScreenState
    extends State<DayStrengthTrainingScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];

  int get _total => 1 + _plan.strength.length;
  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleWarmup(String name) {
    setState(() {
      if (_done.contains('warmup:$name')) {
        _done.remove('warmup:$name');
      } else {
        _done.removeWhere((e) => e.startsWith('warmup:'));
        _done.add('warmup:$name');
      }
    });
  }

  void _toggleStrength(String name) {
    setState(() {
      final key = 'strength:$name';

      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        _done.add(key);
      }
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
          const SizedBox(height: 24),

          Text(
            'Your weight loss goal',
            style: t.titleSmall?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          _goalSelector(t),
          const SizedBox(height: 20),

          _statsRow(t),
          const SizedBox(height: 26),

          _section(
            t,
            title: 'Warm-up',
            subtitle: '${_plan.warmupMin} min  •  Pick one',
            icon: Icons.directions_run,
            note: 'Light cardio to loosen up your joints before lifting.',
            child: Column(
              children: _plan.warmup.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('warmup:${e.title}'),
                      () => _toggleWarmup(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Strength training',
            subtitle: '${_plan.strengthMin} min',
            icon: Icons.fitness_center,
            note: _plan.strengthNote,
            child: Column(
              children: _plan.strength.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('strength:${e.title}'),
                      () => _toggleStrength(e.title),
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
            note: 'Finish your workout with gentle movements.',
            child: Text(
              'Slow walk, then stretch your chest, arms, back and legs. '
                  'Hold each stretch for 20 seconds.',
              style: t.bodyMedium?.copyWith(
                color: _muted,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _tips(t),
          const SizedBox(height: 20),

          _quote(t),
          const SizedBox(height: 20),

          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset(
                'assets/images/dumbbell.png',
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
              onPressed: finished
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Day ${widget.day} complete!'),
                    backgroundColor: _card,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // TODO: Save progress to Firestore here.
                Navigator.maybePop(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                disabledBackgroundColor: const Color(0xFF2A2A2D),
                foregroundColor: Colors.white,
                disabledForegroundColor: _muted,
                elevation: finished ? 4 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (finished) ...[
                    const Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total exercises done',
                    style: t.titleMedium?.copyWith(
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
                  'WEIGHT LOSS',
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
                color: selected
                    ? _orange.withOpacity(0.16)
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
                      color: selected ? _orange : _text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _plans[i].intensity,
                    style: t.bodySmall?.copyWith(
                      color: selected ? _softOrange : _muted,
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
              Icon(icon, color: _orange, size: 22),
              const SizedBox(height: 8),
              Text(
                value,
                style: t.titleMedium?.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
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

    final total = _plan.warmupMin + _plan.strengthMin + 5;

    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total time'),
        const SizedBox(width: 10),
        stat(
          Icons.local_fire_department_outlined,
          '~${_plan.kcal}',
          'Calories',
        ),
        const SizedBox(width: 10),
        stat(
          Icons.bolt_outlined,
          _plan.intensity,
          'Level',
        ),
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
        borderRadius: BorderRadius.circular(20),
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
                  color: _orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
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
            Text(
              note,
              style: t.bodySmall?.copyWith(
                color: _muted,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _exerciseTile(
      TextTheme t,
      _Exercise e,
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
      'Deadlift: keep your back straight and push your hips back as you lower the dumbbells.',
      'Step-ups: use a sturdy bench or step, and push through your heel.',
      'Triceps dips: use a stable chair against a wall so it cannot slide.',
      'Eat protein (eggs, dal, paneer, chicken) and drink 2-3 litres of water.',
    ];

    return _section(
      t,
      title: 'Daily tips',
      subtitle: 'Stay consistent',
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
          color: _orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: _orange,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Treat your body like someone you love.',
              style: t.titleSmall?.copyWith(
                color: _softOrange,
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
