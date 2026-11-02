
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
  final int activityMin;
  final int strengthMin;
  final int mobilityMin;
  final int kcalSurplus;
  final String activityNote;
  final String strengthNote;
  final List<Exercise> activity;
  final List<Exercise> strength;
  final List<Exercise> mobility;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.activityMin,
    required this.strengthMin,
    required this.mobilityMin,
    required this.kcalSurplus,
    required this.activityNote,
    required this.strengthNote,
    required this.activity,
    required this.strength,
    required this.mobility,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    activityMin: 15,
    strengthMin: 15,
    mobilityMin: 15,
    kcalSurplus: 250,
    activityNote:
    'Very easy pace. You should feel better after, not tired.',
    strengthNote:
    'Bodyweight only. Slow reps, stop 3 reps before failure.',
    activity: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, no resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    strength: [
      Exercise('Bodyweight squats', '2 sets x 12 reps', Icons.arrow_downward),
      Exercise('Incline push-ups', '2 sets x 10 reps', Icons.fitness_center),
      Exercise('Glute bridge', '2 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Plank', '2 sets x 30 sec', Icons.accessibility_new),
    ],
    mobility: [
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
      Exercise("Child's pose", '3 x 30 sec', Icons.spa_outlined),
      Exercise('Hamstring stretch', '2 x 30 sec each leg',
          Icons.self_improvement),
      Exercise('Hip flexor stretch', '2 x 30 sec each side',
          Icons.airline_seat_flat),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    activityMin: 15,
    strengthMin: 20,
    mobilityMin: 15,
    kcalSurplus: 400,
    activityNote: 'Easy and steady. Keep your heart rate low.',
    strengthNote:
    'Light dumbbells, about half of your normal working weight.',
    activity: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    strength: [
      Exercise('Goblet squats', '3 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell rows', '3 sets x 10 reps each arm', Icons.sync),
      Exercise('Dumbbell shoulder press', '3 sets x 10 reps',
          Icons.expand_less),
      Exercise('Romanian deadlift', '3 sets x 10 reps', Icons.arrow_upward),
      Exercise('Plank', '3 sets x 40 sec', Icons.accessibility_new),
    ],
    mobility: [
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
      Exercise("Child's pose", '3 x 40 sec', Icons.spa_outlined),
      Exercise('Hamstring stretch', '3 x 30 sec each leg',
          Icons.self_improvement),
      Exercise('Chest and shoulder stretch', '3 x 30 sec', Icons.expand_less),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    activityMin: 15,
    strengthMin: 25,
    mobilityMin: 15,
    kcalSurplus: 500,
    activityNote:
    'Keep it easy. Today you recover so tomorrow you grow.',
    strengthNote:
    'Moderate weight, controlled reps. Not a max-effort day.',
    activity: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    strength: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell bench press', '3 sets x 10 reps',
          Icons.fitness_center),
      Exercise('Dumbbell rows', '3 sets x 10 reps each arm', Icons.sync),
      Exercise('Romanian deadlift', '3 sets x 10 reps', Icons.arrow_upward),
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Weighted plank', '3 sets x 40 sec', Icons.accessibility_new),
    ],
    mobility: [
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
      Exercise("Child's pose", '3 x 45 sec', Icons.spa_outlined),
      Exercise('Hamstring stretch', '3 x 40 sec each leg',
          Icons.self_improvement),
      Exercise('Hip flexor stretch', '3 x 40 sec each side',
          Icons.airline_seat_flat),
      Exercise('Spinal twist', '3 x 30 sec each side', Icons.rotate_right),
    ],
  ),
];

class DayGainRecoveryScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainRecoveryScreen({
    super.key,
    this.day = 6,
    this.title = 'Recovery + Strength',
  });

  @override
  State<DayGainRecoveryScreen> createState() =>
      _DayGainRecoveryScreenState();
}

class _DayGainRecoveryScreenState extends State<DayGainRecoveryScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total => 1 + _plan.strength.length + _plan.mobility.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleActivity(String name) {
    setState(() {
      if (_done.contains('act:$name')) {
        _done.remove('act:$name');
      } else {
        _done.removeWhere((e) => e.startsWith('act:'));
        _done.add('act:$name');
      }
    });
  }

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

          _sectionHeading(
            t,
            'Your weight gain goal',
            'Choose your recovery level',
          ),
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
              'Arm circles, hip rotations and a slow walk. Move gently and let your body loosen up.',
              style: t.bodyMedium?.copyWith(
                color: _muted,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Light activity',
            subtitle: '${_plan.activityMin} min',
            icon: Icons.directions_walk,
            note: _plan.activityNote,
            child: Column(
              children: [
                _pickOneLabel(t),
                const SizedBox(height: 8),
                ..._plan.activity.map((e) {
                  return _exerciseTile(
                    t,
                    e,
                    _done.contains('act:${e.title}'),
                        () => _toggleActivity(e.title),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Light strength',
            subtitle: '${_plan.strengthMin} min',
            icon: Icons.fitness_center,
            note: _plan.strengthNote,
            child: Column(
              children: _plan.strength.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('str:${e.title}'),
                      () => _toggle('str:${e.title}'),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Mobility',
            subtitle: '${_plan.mobilityMin} min',
            icon: Icons.self_improvement,
            note: 'Stretch until you feel tension, never pain. Breathe slowly.',
            child: Column(
              children: _plan.mobility.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('mob:${e.title}'),
                      () => _toggle('mob:${e.title}'),
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
            child: Text(
              'Slow walk and deep breathing. Inhale for 4 seconds, exhale for 6 seconds, and let your heart rate settle.',
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
              top: BorderSide(
                color: _border.withValues(alpha: 0.7),
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
                    finished
                        ? Icons.check_circle_outline
                        : Icons.lock_outline,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total done',
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
                const SizedBox(height: 7),

                Text(
                  'Today\'s progress',
                  style: t.bodySmall?.copyWith(color: _muted),
                ),
                const SizedBox(height: 14),

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
                  '$_completed / $_total completed',
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

    final total = _plan.activityMin +
        _plan.strengthMin +
        _plan.mobilityMin +
        10;

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

  Widget _pickOneLabel(TextTheme t) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _orange.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.touch_app_outlined,
            color: _orange,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            'Choose any one activity',
            style: t.bodySmall?.copyWith(
              color: _softOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
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
      'Keep eating in a surplus today. Recovery days are when your body builds.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Drink 2-3 litres of water to help your muscles recover.',
      'If you feel very sore, choose the lighter option and skip extra sets.',
      'Sleep 7-9 hours. Tomorrow is your rest day, so finish the week strong.',
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
              Icons.spa_outlined,
              color: _orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recovery is part of the training.',
                  style: t.titleSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rest well. Recover well. Come back stronger.',
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
