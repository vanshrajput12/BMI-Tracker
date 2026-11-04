
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _orange = Color(0xFFFF8A24);
const _softOrange = Color(0xFFFFB366);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _border = Color(0xFF303034);

class Exercise {
  final String title;
  final String detail;
  final IconData icon;

  const Exercise(this.title, this.detail, this.icon);
}

class GainPlan {
  final String label;
  final String intensity;
  final int hiitMin;
  final int finisherMin;
  final int kcalSurplus;
  final String hiitPattern;
  final String hiitNote;
  final String finisherNote;
  final List<Exercise> hiit;
  final List<Exercise> finisher;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.hiitMin,
    required this.finisherMin,
    required this.kcalSurplus,
    required this.hiitPattern,
    required this.hiitNote,
    required this.finisherNote,
    required this.hiit,
    required this.finisher,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    hiitMin: 20,
    finisherMin: 10,
    kcalSurplus: 250,
    hiitPattern: '30 sec work / 60 sec rest x 3 rounds',
    hiitNote:
    'Go hard for the short burst, then rest fully. Rest is part of the plan.',
    finisherNote: 'Light dumbbells. Slow and controlled.',
    hiit: [
      Exercise('Squat jumps', '30 sec, land softly', Icons.arrow_upward),
      Exercise('Push-ups', '30 sec, steady pace', Icons.fitness_center),
      Exercise('High knees', '30 sec, fast', Icons.directions_run),
      Exercise('Glute bridge', '30 sec, squeeze at the top', Icons.airline_seat_flat),
    ],
    finisher: [
      Exercise('Dumbbell goblet squat', '3 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell shoulder press', '3 sets x 10 reps', Icons.expand_less),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    hiitMin: 25,
    finisherMin: 15,
    kcalSurplus: 400,
    hiitPattern: '40 sec work / 50 sec rest x 4 rounds',
    hiitNote:
    'Hard effort, but keep your form clean. Stop a set if it breaks down.',
    finisherNote: 'Moderate dumbbells. Last 2 reps should feel hard.',
    hiit: [
      Exercise('Dumbbell thrusters', '40 sec, light weight', Icons.arrow_upward),
      Exercise('Jump squats', '40 sec, land softly', Icons.height),
      Exercise('Push-ups', '40 sec, steady pace', Icons.fitness_center),
      Exercise('Mountain climbers', '40 sec, fast', Icons.terrain),
      Exercise('Dumbbell swings', '40 sec, hips drive the weight', Icons.sync),
    ],
    finisher: [
      Exercise('Dumbbell Romanian deadlift', '3 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell rows', '3 sets x 10 reps each arm', Icons.sync),
      Exercise('Plank', '3 sets x 40 sec', Icons.accessibility_new),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    hiitMin: 30,
    finisherMin: 15,
    kcalSurplus: 500,
    hiitPattern: '40 sec work / 60 sec rest x 4 rounds',
    hiitNote:
    'Explosive reps with real rest. Keep the weight light enough to move fast.',
    finisherNote: 'Heavy and slow. This is where the muscle is built.',
    hiit: [
      Exercise('Kettlebell or dumbbell swings', '40 sec, explosive hips', Icons.sync),
      Exercise('Dumbbell thrusters', '40 sec, moderate weight', Icons.arrow_upward),
      Exercise('Jump squats', '40 sec, land softly', Icons.height),
      Exercise('Burpees', '40 sec, steady pace', Icons.directions_run),
      Exercise('Push-ups', '40 sec, fast and clean', Icons.fitness_center),
      Exercise('Mountain climbers', '40 sec, fast', Icons.terrain),
    ],
    finisher: [
      Exercise('Barbell or dumbbell squat', '4 sets x 8 reps', Icons.arrow_downward),
      Exercise('Bent-over rows', '4 sets x 8 reps', Icons.sync),
      Exercise('Weighted plank', '3 sets x 45 sec', Icons.accessibility_new),
    ],
  ),
];

class DayGainHiitScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainHiitScreen({
    super.key,
    this.day = 4,
    this.title = 'HIIT',
  });

  @override
  State<DayGainHiitScreen> createState() => _DayGainHiitScreenState();
}

class _DayGainHiitScreenState extends State<DayGainHiitScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total => _plan.hiit.length + _plan.finisher.length;

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
              'Jumping jacks, arm circles, bodyweight squats and leg swings. '
                  'HIIT is explosive, so warm up properly.',
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'HIIT circuit',
            subtitle: '${_plan.hiitMin} min',
            icon: Icons.bolt,
            note: '${_plan.hiitPattern}\n${_plan.hiitNote}',
            child: Column(
              children: _plan.hiit.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('hiit:${e.title}'),
                      () => _toggle('hiit:${e.title}'),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Strength finisher',
            subtitle: '${_plan.finisherMin} min • Rest 60 sec',
            icon: Icons.fitness_center,
            note: _plan.finisherNote,
            child: Column(
              children: _plan.finisher.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('fin:${e.title}'),
                      () => _toggle('fin:${e.title}'),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            icon: Icons.spa_outlined,
            child: _description(
              t,
              'Slow walk until your breathing settles, then stretch your '
                  'quads, hamstrings and shoulders. Hold each stretch for '
                  '20 seconds.',
            ),
          ),

          const SizedBox(height: 16),

          _tips(t),
          const SizedBox(height: 20),

          _quote(t),
          const SizedBox(height: 16),

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
          style: t.bodySmall?.copyWith(
            color: _muted,
          ),
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

    final total = _plan.hiitMin + _plan.finisherMin + 10;

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
                    ? _orange.withOpacity(0.14)
                    : _orange.withOpacity(0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                e.icon,
                color: _orange,
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
              color: done ? _orange : Colors.white24,
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
      'Eat a small carb snack 1 hour before: banana, oats or toast with peanut butter.',
      'Have protein and carbs within 1-2 hours after: eggs with rice, paneer or dal.',
      'Do not shorten the rests. Full rest keeps your power high and protects your muscle.',
      'Drink 2-3 litres of water. You will sweat more on HIIT days.',
      'Stop and rest if you feel dizzy or sharp pain. Never push through it.',
    ];

    return _section(
      t,
      title: 'Daily tips',
      subtitle: 'Train smart and recover well',
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
              Icons.bolt,
              color: _orange,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Text(
              'Short bursts. Full effort. Full rest.',
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
