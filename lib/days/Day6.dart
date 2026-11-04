
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
  final int activityMin;
  final int stretchMin;
  final int kcal;
  final String activityNote;
  final String stretchNote;
  final List<_Exercise> activity;
  final List<_Exercise> stretches;

  const _GoalPlan({
    required this.label,
    required this.intensity,
    required this.activityMin,
    required this.stretchMin,
    required this.kcal,
    required this.activityNote,
    required this.stretchNote,
    required this.activity,
    required this.stretches,
  });
}

const _plans = <_GoalPlan>[
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    activityMin: 40,
    stretchMin: 15,
    kcal: 200,
    activityNote:
    'Very easy pace. You should be able to chat the whole time.',
    stretchNote: 'Hold each stretch 45 sec, 3 rounds. Breathe slowly.',
    activity: [
      _Exercise(
        'Easy walking',
        '40 min, relaxed pace',
        Icons.directions_walk,
      ),
      _Exercise(
        'Or cycling',
        '40 min, no resistance',
        Icons.pedal_bike,
      ),
      _Exercise(
        'Or swimming',
        '30-40 min, slow laps',
        Icons.pool,
      ),
    ],
    stretches: [
      _Exercise(
        'Seated spinal twist',
        '45 sec each side x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Knee-to-chest stretch',
        '45 sec each leg x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Butterfly stretch',
        '45 sec x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        "Child's pose",
        '45 sec x 3',
        Icons.self_improvement,
      ),
    ],
  ),
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    activityMin: 40,
    stretchMin: 20,
    kcal: 240,
    activityNote:
    'Easy to comfortable pace. Do not push hard on a recovery day.',
    stretchNote: 'Hold each stretch 60 sec, 3 rounds. Breathe slowly.',
    activity: [
      _Exercise(
        'Walking',
        '40 min, comfortable pace',
        Icons.directions_walk,
      ),
      _Exercise(
        'Or cycling',
        '40 min, light resistance',
        Icons.pedal_bike,
      ),
      _Exercise(
        'Or swimming',
        '30-40 min, steady laps',
        Icons.pool,
      ),
    ],
    stretches: [
      _Exercise(
        'Seated spinal twist',
        '60 sec each side x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Knee-to-chest stretch',
        '60 sec each leg x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Butterfly stretch',
        '60 sec x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        "Child's pose",
        '60 sec x 3',
        Icons.self_improvement,
      ),
    ],
  ),
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    activityMin: 45,
    stretchMin: 20,
    kcal: 290,
    activityNote:
    'Easy to comfortable pace. This is still a recovery day, '
        'so keep your heart rate low.',
    stretchNote: 'Hold each stretch 60 sec, 3 rounds. Breathe slowly.',
    activity: [
      _Exercise(
        'Walking',
        '45 min, steady pace',
        Icons.directions_walk,
      ),
      _Exercise(
        'Or cycling',
        '45 min, light resistance',
        Icons.pedal_bike,
      ),
      _Exercise(
        'Or swimming',
        '40 min, steady laps',
        Icons.pool,
      ),
    ],
    stretches: [
      _Exercise(
        'Seated spinal twist',
        '60 sec each side x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Knee-to-chest stretch',
        '60 sec each leg x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Butterfly stretch',
        '60 sec x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        "Child's pose",
        '60 sec x 3',
        Icons.self_improvement,
      ),
      _Exercise(
        'Cat-cow',
        '2 sets x 10 slow reps',
        Icons.self_improvement,
      ),
    ],
  ),
];

class DayRecoveryScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayRecoveryScreen({
    super.key,
    this.day = 6,
    this.title = 'Recovery + Strength',
  });

  @override
  State<DayRecoveryScreen> createState() => _DayRecoveryScreenState();
}

class _DayRecoveryScreenState extends State<DayRecoveryScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];

  // Light activity is pick one, so it counts as one task.
  int get _total => 1 + _plan.stretches.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleActivity(String name) {
    setState(() {
      if (_done.contains('activity:$name')) {
        _done.remove('activity:$name');
      } else {
        _done.removeWhere((e) => e.startsWith('activity:'));
        _done.add('activity:$name');
      }
    });
  }

  void _toggleStretch(String name) {
    setState(() {
      final key = 'stretch:$name';

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
            title: 'Light activity',
            subtitle: '${_plan.activityMin} min • Pick one',
            icon: Icons.directions_walk,
            note: _plan.activityNote,
            child: Column(
              children: _plan.activity.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('activity:${e.title}'),
                      () => _toggleActivity(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Flexibility work',
            subtitle: '${_plan.stretchMin} min',
            icon: Icons.self_improvement,
            note: _plan.stretchNote,
            child: Column(
              children: _plan.stretches.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('stretch:${e.title}'),
                      () => _toggleStretch(e.title),
                );
              }).toList(),
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
                'assets/images/clock.png',
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
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total activities done',
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

    final total = _plan.activityMin + _plan.stretchMin;

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
                child: Icon(
                  icon,
                  color: _orange,
                  size: 20,
                ),
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
      _Exercise e,
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
      'Recovery days are part of the plan. Muscles get stronger while they rest.',
      'Keep it easy today. Save your hard effort for the next workout.',
      'Sleep 7-8 hours and drink 2-3 litres of water.',
      'Go to a gentle pull in each stretch, never to pain. Do not bounce.',
    ];

    return _section(
      t,
      title: 'Daily tips',
      subtitle: 'Recover and recharge',
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
              Icons.timer_outlined,
              color: _orange,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'The clock is ticking. Are you becoming the person you want to be?',
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
