
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
  final int cardioMin;
  final int stretchMin;
  final int kcal;
  final String cardioNote;
  final String stretchNote;
  final List<_Exercise> cardio;
  final List<_Exercise> stretches;

  const _GoalPlan({
    required this.label,
    required this.intensity,
    required this.cardioMin,
    required this.stretchMin,
    required this.kcal,
    required this.cardioNote,
    required this.stretchNote,
    required this.cardio,
    required this.stretches,
  });
}

const _plans = <_GoalPlan>[
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 30,
    stretchMin: 10,
    kcal: 220,
    cardioNote:
    'Keep a steady pace. You should be able to talk while moving.',
    stretchNote: 'Hold each stretch 20 sec, 2 rounds. Breathe slowly.',
    cardio: [
      _Exercise('Easy jogging', '30 min, steady pace', Icons.directions_run),
      _Exercise('Or dancing', '30 min, any music you like', Icons.music_note),
      _Exercise('Or brisk walk', '30 min, fast pace', Icons.directions_walk),
    ],
    stretches: [
      _Exercise('Hamstring stretch', '20 sec each leg x 2', Icons.self_improvement),
      _Exercise('Quadriceps stretch', '20 sec each leg x 2', Icons.self_improvement),
      _Exercise('Shoulder and chest stretch', '20 sec x 2', Icons.self_improvement),
      _Exercise('Hip flexor stretch', '20 sec each side x 2', Icons.self_improvement),
    ],
  ),
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 35,
    stretchMin: 10,
    kcal: 330,
    cardioNote: 'Warm up 5 min, then alternate 3 min fast + 1 min easy.',
    stretchNote: 'Hold each stretch 30 sec, 2 rounds. Breathe slowly.',
    cardio: [
      _Exercise(
        'Jogging intervals',
        '35 min, 3 min fast + 1 min easy',
        Icons.directions_run,
      ),
      _Exercise('Or dancing', '35 min, high energy', Icons.music_note),
      _Exercise(
        'Or power walk',
        '35 min, add hills or stairs',
        Icons.directions_walk,
      ),
    ],
    stretches: [
      _Exercise('Hamstring stretch', '30 sec each leg x 2', Icons.self_improvement),
      _Exercise('Quadriceps stretch', '30 sec each leg x 2', Icons.self_improvement),
      _Exercise('Shoulder and chest stretch', '30 sec x 2', Icons.self_improvement),
      _Exercise('Hip flexor stretch', '30 sec each side x 2', Icons.self_improvement),
      _Exercise('Calf stretch', '30 sec each leg x 2', Icons.self_improvement),
    ],
  ),
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 45,
    stretchMin: 12,
    kcal: 450,
    cardioNote: 'Warm up 5 min, then alternate 2 min hard + 1 min easy.',
    stretchNote: 'Hold each stretch 30 sec, 3 rounds. Breathe slowly.',
    cardio: [
      _Exercise(
        'Jogging / running intervals',
        '45 min, 2 min hard + 1 min easy',
        Icons.directions_run,
      ),
      _Exercise('Or dance workout', '45 min, high intensity', Icons.music_note),
      _Exercise(
        'Or incline power walk',
        '45 min, fast with hills',
        Icons.directions_walk,
      ),
    ],
    stretches: [
      _Exercise('Hamstring stretch', '30 sec each leg x 3', Icons.self_improvement),
      _Exercise('Quadriceps stretch', '30 sec each leg x 3', Icons.self_improvement),
      _Exercise('Shoulder and chest stretch', '30 sec x 3', Icons.self_improvement),
      _Exercise('Hip flexor stretch', '30 sec each side x 3', Icons.self_improvement),
      _Exercise('Calf stretch', '30 sec each leg x 3', Icons.self_improvement),
      _Exercise("Child's pose", '45 sec x 2', Icons.self_improvement),
    ],
  ),
];

class DayFlexibilityScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayFlexibilityScreen({
    super.key,
    this.day = 3,
    this.title = 'Cardio + Flexibility',
  });

  @override
  State<DayFlexibilityScreen> createState() =>
      _DayFlexibilityScreenState();
}

class _DayFlexibilityScreenState extends State<DayFlexibilityScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];

  int get _total => 1 + _plan.stretches.length;

  int get _completed => _done.length;

  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleCardio(String name) {
    setState(() {
      if (_done.contains('cardio:$name')) {
        _done.remove('cardio:$name');
      } else {
        _done.removeWhere((e) => e.startsWith('cardio:'));
        _done.add('cardio:$name');
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
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _header(t),

          const SizedBox(height: 26),

          _sectionHeading(
            t,
            'Your weight loss goal',
            'Choose your target',
          ),

          const SizedBox(height: 12),

          _goalSelector(t),

          const SizedBox(height: 22),

          _statsRow(t),

          const SizedBox(height: 28),

          _section(
            t,
            title: 'Cardio',
            subtitle: '${_plan.cardioMin} min  •  Pick one',
            note: _plan.cardioNote,
            icon: Icons.directions_run,
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
            title: 'Flexibility & stretching',
            subtitle: '${_plan.stretchMin} min',
            note: _plan.stretchNote,
            icon: Icons.self_improvement,
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
                'assets/images/stretching.png',
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
            height: 56,
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

                // TODO: Save progress to Firestore.
                Navigator.maybePop(context);
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
                    const Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 9),
                  ],
                  Text(
                    finished
                        ? 'Complete Day ${widget.day}'
                        : '$_completed of $_total completed',
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
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: t.bodySmall!.copyWith(
            color: _muted,
          ),
        ),
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
            onTap: () {
              setState(() {
                _goal = i;
                _done.clear();
              });
            },
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
              Icon(
                icon,
                color: _orange,
                size: 21,
              ),
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

    final total = _plan.cardioMin + _plan.stretchMin;

    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total'),
        const SizedBox(width: 10),
        stat(
          Icons.local_fire_department_outlined,
          '~${_plan.kcal}',
          'kcal',
        ),
        const SizedBox(width: 10),
        stat(Icons.bolt_outlined, _plan.intensity, 'Level'),
      ],
    );
  }

  // EXERCISE SECTION

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
        borderRadius: BorderRadius.circular(21),
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

  // EXERCISE TILE

  Widget _exerciseTile(
      TextTheme t,
      _Exercise e,
      bool done,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: _orange.withOpacity(done ? 0.18 : 0.11),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                e.icon,
                color: _orange,
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
      'Stretch when your muscles are warm, right after cardio.',
      'Go to a gentle pull, never to pain. Do not bounce.',
      'Drink 2-3 litres of water today.',
      'Good flexibility helps you recover and lowers injury risk on strength days.',
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
              Icons.self_improvement,
              color: _orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Push harder than yesterday, if you want a different tomorrow.',
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
