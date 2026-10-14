// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _red = Color(0xFFFF4D3D);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);

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
  final int kcal; // rough estimate only
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
  // 1 - 2 kg
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    warmupMin: 5,
    strengthMin: 30,
    kcal: 200,
    strengthNote: 'Light to moderate dumbbells. Rest 45 sec between sets.',
    warmup: [
      _Exercise('Light walking', '5 min, easy pace', Icons.directions_walk),
      _Exercise('Or cycling', '5 min, no resistance', Icons.pedal_bike),
    ],
    strength: [
      _Exercise('Squats', '3 sets x 15 reps', Icons.airline_seat_legroom_extra),
      _Exercise('Dumbbell rows', '3 sets x 12 reps', Icons.fitness_center),
      _Exercise('Push-ups', '3 sets x 10 reps', Icons.accessibility_new),
      _Exercise('Dumbbell shoulder press', '3 sets x 12 reps',
          Icons.keyboard_double_arrow_up),
    ],
  ),
  // 3 - 4 kg
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    warmupMin: 8,
    strengthMin: 35,
    kcal: 300,
    strengthNote: 'Moderate dumbbells. Rest 45 sec between sets.',
    warmup: [
      _Exercise('Brisk walking', '8 min, raise your heart rate',
          Icons.directions_walk),
      _Exercise('Or cycling', '8 min, light resistance', Icons.pedal_bike),
    ],
    strength: [
      _Exercise('Squats', '3 sets x 15 reps', Icons.airline_seat_legroom_extra),
      _Exercise('Dumbbell rows', '3 sets x 15 reps', Icons.fitness_center),
      _Exercise('Push-ups', '3 sets x 12 reps', Icons.accessibility_new),
      _Exercise('Dumbbell shoulder press', '3 sets x 15 reps',
          Icons.keyboard_double_arrow_up),
      _Exercise('Walking lunges', '3 sets x 12 reps each leg',
          Icons.directions_walk),
    ],
  ),
  // 5 kg
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    warmupMin: 10,
    strengthMin: 40,
    kcal: 420,
    strengthNote: 'Heavier dumbbells. Rest 30-45 sec between sets.',
    warmup: [
      _Exercise('Brisk walk / light jog', '10 min, build up slowly',
          Icons.directions_run),
      _Exercise('Or cycling', '10 min, moderate resistance', Icons.pedal_bike),
    ],
    strength: [
      _Exercise('Squats', '4 sets x 15 reps', Icons.airline_seat_legroom_extra),
      _Exercise('Dumbbell rows', '4 sets x 15 reps', Icons.fitness_center),
      _Exercise('Push-ups', '4 sets x 15 reps', Icons.accessibility_new),
      _Exercise('Dumbbell shoulder press', '4 sets x 15 reps',
          Icons.keyboard_double_arrow_up),
      _Exercise('Walking lunges', '3 sets x 12 reps each leg',
          Icons.directions_walk),
      _Exercise('Plank', '3 sets x 45 sec', Icons.timer_outlined),
    ],
  ),
];

class DayStrengthScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayStrengthScreen(
      {super.key, this.day = 2, this.title = 'Full Strength Training'});

  @override
  State<DayStrengthScreen> createState() => _DayStrengthScreenState();
}

class _DayStrengthScreenState extends State<DayStrengthScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];
  // Warm-up is "pick one" so it counts as one task.
  int get _total => 1 + _plan.strength.length;
  int get _completed => _done.length;
  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleWarmup(String name) => setState(() {
    if (_done.contains('warmup:$name')) {
      _done.remove('warmup:$name');
    } else {
      _done.removeWhere((e) => e.startsWith('warmup:'));
      _done.add('warmup:$name');
    }
  });

  void _toggleStrength(String name) => setState(() {
    final key = 'strength:$name';
    _done.contains(key) ? _done.remove(key) : _done.add(key);
  });

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    final finished = _completed >= _total;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: _text),
        title: Text('Day ${widget.day}',
            style: t.titleLarge!
                .copyWith(color: _text, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
        children: [
          _header(t),
          const SizedBox(height: 20),
          Text('Your weight loss goal',
              style: t.titleSmall!.copyWith(color: _muted)),
          const SizedBox(height: 10),
          _goalSelector(t),
          const SizedBox(height: 20),
          _statsRow(t),
          const SizedBox(height: 24),
          _section(
            t,
            title: 'Warm-up',
            subtitle: '${_plan.warmupMin} min  |  pick one',
            note: 'Light cardio to loosen up your joints before lifting.',
            child: Column(
              children: _plan.warmup
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('warmup:${e.title}'),
                      () => _toggleWarmup(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Strength training',
            subtitle: '${_plan.strengthMin} min',
            note: _plan.strengthNote,
            child: Column(
              children: _plan.strength
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('strength:${e.title}'),
                      () => _toggleStrength(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk, then stretch your legs, chest, back and shoulders. Hold each stretch for 20 seconds.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _tips(t),
          const SizedBox(height: 24),
          _quote(t),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: finished
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Day ${widget.day} complete!')));
                // TODO: save progress to Firestore here.
                Navigator.maybePop(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                disabledBackgroundColor: const Color(0xFF2A2A2D),
                foregroundColor: Colors.white,
                disabledForegroundColor: _muted,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                finished
                    ? 'Complete Day ${widget.day}'
                    : '$_completed of $_total done',
                style: t.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.white),
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
          colors: [Color(0xFF3A1511), Color(0xFF1C1C1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: t.headlineSmall!
                        .copyWith(color: _text, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text("Today's progress",
                    style: t.bodySmall!.copyWith(color: _muted)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(_amber),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(_red),
                ),
                Text('${(_progress * 100).round()}%',
                    style: t.titleSmall!.copyWith(
                        color: _text, fontWeight: FontWeight.w600)),
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
            onTap: () => setState(() {
              _goal = i;
              _done.clear();
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i == _plans.length - 1 ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? _red : _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? _red : Colors.white12),
              ),
              child: Column(
                children: [
                  Text(_plans[i].label,
                      style: t.titleSmall!.copyWith(
                          color: selected ? Colors.white : _text,
                          fontWeight: FontWeight.w600)),
                  Text(_plans[i].intensity,
                      style: t.bodySmall!.copyWith(
                          color: selected ? Colors.white70 : _muted)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _statsRow(TextTheme t) {
    Widget stat(IconData icon, String value, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
            color: _card, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Icon(icon, color: _amber, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: t.titleMedium!.copyWith(
                    color: _text, fontWeight: FontWeight.w600)),
            Text(label, style: t.bodySmall!.copyWith(color: _muted)),
          ],
        ),
      ),
    );

    final total = _plan.warmupMin + _plan.strengthMin + 5;
    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total'),
        const SizedBox(width: 10),
        stat(Icons.local_fire_department_outlined, '~${_plan.kcal}', 'kcal'),
        const SizedBox(width: 10),
        stat(Icons.bolt_outlined, _plan.intensity, 'Level'),
      ],
    );
  }

  Widget _section(TextTheme t,
      {required String title,
        required String subtitle,
        String? note,
        required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: _card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: _red, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(title,
                  style: t.titleMedium!
                      .copyWith(color: _red, fontWeight: FontWeight.w700)),
              const Spacer(),
              Flexible(
                child: Text(subtitle,
                    textAlign: TextAlign.right,
                    style: t.bodySmall!.copyWith(color: _muted)),
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 8),
            Text(note,
                style: t.bodySmall!.copyWith(color: _muted, height: 1.4)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _exerciseTile(
      TextTheme t, _Exercise e, bool done, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (done ? _amber : _red).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(e.icon, color: done ? _amber : _red, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title,
                      style: t.bodyLarge!.copyWith(
                          color: done ? _muted : _text,
                          fontWeight: FontWeight.w500,
                          decoration:
                          done ? TextDecoration.lineThrough : null)),
                  Text(e.detail,
                      style: t.bodySmall!.copyWith(color: _muted)),
                ],
              ),
            ),
            Icon(done ? Icons.check_circle : Icons.circle_outlined,
                color: done ? _amber : Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _tips(TextTheme t) {
    const tips = [
      'Form first: use a lighter weight and full control for every rep.',
      'Eat protein (eggs, dal, paneer, chicken) to help muscles recover.',
      'Drink 2-3 litres of water today.',
      'Mild muscle soreness is normal. Sharp pain is not, so stop if you feel it.',
    ];
    return _section(
      t,
      title: 'Daily tips',
      subtitle: '',
      child: Column(
        children: tips
            .map((s) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check, color: _amber, size: 18),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(s,
                      style: t.bodyMedium!
                          .copyWith(color: _muted, height: 1.4))),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget _quote(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _amber.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: _amber, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Once you are exercising regularly, the hardest thing is to stop it.',
              style: t.titleMedium!
                  .copyWith(color: _amber, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}