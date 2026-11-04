
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
  final int cardioMin;
  final int flexMin;
  final int kcalSurplus;
  final String cardioNote;
  final String flexNote;
  final List<Exercise> cardio;
  final List<Exercise> flex;

  const GainPlan({
    required this.label,
    required this.intensity,
    required this.cardioMin,
    required this.flexMin,
    required this.kcalSurplus,
    required this.cardioNote,
    required this.flexNote,
    required this.cardio,
    required this.flex,
  });
}

const _plans = <GainPlan>[
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 15,
    flexMin: 15,
    kcalSurplus: 250,
    cardioNote: 'Easy pace. This is active recovery, not a hard session.',
    flexNote: 'Move slowly. Stretch until you feel tension, never pain.',
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
    flex: [
      Exercise(
        'Hamstring stretch',
        '3 x 20 sec each leg',
        Icons.self_improvement,
      ),
      Exercise(
        'Quad stretch',
        '3 x 20 sec each leg',
        Icons.accessibility_new,
      ),
      Exercise(
        "Child's pose",
        '3 x 30 sec',
        Icons.spa_outlined,
      ),
      Exercise(
        'Cat-cow',
        '10 slow reps',
        Icons.sync,
      ),
    ],
  ),
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 20,
    flexMin: 20,
    kcalSurplus: 400,
    cardioNote:
    'Steady and comfortable. Keep energy for tomorrow\'s lifting.',
    flexNote: 'Focus on the muscles you trained on Day 2.',
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
    flex: [
      Exercise(
        'Hamstring stretch',
        '3 x 30 sec each leg',
        Icons.self_improvement,
      ),
      Exercise(
        'Quad stretch',
        '3 x 30 sec each leg',
        Icons.accessibility_new,
      ),
      Exercise(
        'Hip flexor stretch',
        '3 x 30 sec each side',
        Icons.airline_seat_flat,
      ),
      Exercise(
        'Chest and shoulder stretch',
        '3 x 30 sec',
        Icons.expand_less,
      ),
      Exercise(
        "Child's pose",
        '3 x 40 sec',
        Icons.spa_outlined,
      ),
    ],
  ),
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 22,
    flexMin: 25,
    kcalSurplus: 500,
    cardioNote:
    'Keep it light to moderate. Heavy lifting needs fresh legs.',
    flexNote:
    'Longer holds help heavy-lifting recovery. Breathe slowly.',
    cardio: [
      Exercise(
        'Brisk walking',
        '22 min, steady pace',
        Icons.directions_walk,
      ),
      Exercise(
        'Or cycling',
        '22 min, light to moderate',
        Icons.pedal_bike,
      ),
      Exercise(
        'Or swimming',
        '22 min, easy laps',
        Icons.pool,
      ),
    ],
    flex: [
      Exercise(
        'Hamstring stretch',
        '3 x 40 sec each leg',
        Icons.self_improvement,
      ),
      Exercise(
        'Quad stretch',
        '3 x 40 sec each leg',
        Icons.accessibility_new,
      ),
      Exercise(
        'Hip flexor stretch',
        '3 x 40 sec each side',
        Icons.airline_seat_flat,
      ),
      Exercise(
        'Chest and shoulder stretch',
        '3 x 40 sec',
        Icons.expand_less,
      ),
      Exercise(
        'Spinal twist',
        '3 x 30 sec each side',
        Icons.rotate_right,
      ),
      Exercise(
        "Child's pose",
        '3 x 45 sec',
        Icons.spa_outlined,
      ),
    ],
  ),
];

class DayGainFlexibilityScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainFlexibilityScreen({
    super.key,
    this.day = 3,
    this.title = 'Cardio + Flexibility',
  });

  @override
  State<DayGainFlexibilityScreen> createState() =>
      _DayGainFlexibilityScreenState();
}

class _DayGainFlexibilityScreenState
    extends State<DayGainFlexibilityScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];

  int get _total => 1 + _plan.flex.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  bool get _finished => _completed >= _total;

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

  void _toggleFlex(String name) {
    setState(() {
      final key = 'flex:$name';

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
              'Arm circles, hip rotations and a slow walk. '
                  'Get your body moving gently before you start.',
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Cardio',
            subtitle: '${_plan.cardioMin} min • Pick one',
            icon: Icons.favorite_border,
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

          const SizedBox(height: 16),

          _section(
            t,
            title: 'Flexibility',
            subtitle: '${_plan.flexMin} min • Hold, do not bounce',
            icon: Icons.self_improvement,
            note: _plan.flexNote,
            child: Column(
              children: _plan.flex.map((e) {
                return _exerciseTile(
                  t,
                  e,
                  _done.contains('flex:${e.title}'),
                      () => _toggleFlex(e.title),
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
              'Slow walk and deep breathing. Inhale for 4 seconds, '
                  'exhale for 6 seconds, and let your heart rate settle.',
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
                        : '$_completed of $_total activities done',
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

    final total = _plan.cardioMin + _plan.flexMin + 10;

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
                color: _orange.withOpacity(done ? 0.18 : 0.13),
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
      'Drink 2-3 litres of water throughout the day.',
      'Keep eating in a surplus even on lighter days. Recovery needs fuel.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Stretching improves your range of motion, which helps your lifts.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
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
              Icons.self_improvement,
              color: _orange,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Text(
              'Rest and recovery build the strength.',
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
