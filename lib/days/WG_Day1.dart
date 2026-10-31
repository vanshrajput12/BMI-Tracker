// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF000000);
const _card = Color(0xFF151515);
const _orange = Color(0xFFFF9800); // accent only
const _text = Color(0xFFFFFFFF);
const _muted = Color(0xFF9E9E9E);

class Exercise {
  final String title;
  final String detail;
  final IconData icon;
  const Exercise(this.title, this.detail, this.icon);
}

class GainPlan {
  final String label; // chip label
  final String intensity;
  final int cardioMin;
  final int coreMin;
  final int kcalSurplus; // rough daily surplus target
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
  // 1 - 2 kg : light cardio, basic core
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 15,
    coreMin: 15,
    kcalSurplus: 250,
    cardioNote: 'Keep it light. Too much cardio burns the calories you need.',
    cardio: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    core: [
      Exercise('Plank', '3 sets x 30 sec', Icons.accessibility_new),
      Exercise('Dead bug', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Leg raises', '3 sets x 10 reps', Icons.sync),
    ],
  ),
  // 3 - 4 kg : short cardio, weighted core
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 20,
    coreMin: 20,
    kcalSurplus: 400,
    cardioNote: 'Short and steady. Save your energy for the core work.',
    cardio: [
      Exercise('Brisk walking', '20 min, steady pace', Icons.directions_walk),
      Exercise('Or cycling', '20 min, moderate resistance', Icons.pedal_bike),
      Exercise('Or swimming', '20 min, easy laps', Icons.pool),
    ],
    core: [
      Exercise('Weighted crunches', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Plank', '3 sets x 45 sec', Icons.accessibility_new),
      Exercise('Leg raises', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise(
          'Weighted Russian twists', '3 sets x 15 reps', Icons.rotate_right),
    ],
  ),
  // 5 kg : light cardio, heavy core volume
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 20,
    coreMin: 30,
    kcalSurplus: 500,
    cardioNote: 'Light only. Your main work today is the heavy core sets.',
    cardio: [
      Exercise('Brisk walking', '20 min, steady pace', Icons.directions_walk),
      Exercise('Or cycling', '20 min, light to moderate', Icons.pedal_bike),
      Exercise('Or swimming', '20 min, easy laps', Icons.pool),
    ],
    core: [
      Exercise('Weighted plank', '4 sets x 45 sec', Icons.accessibility_new),
      Exercise(
          'Weighted Russian twists', '4 sets x 16 reps', Icons.rotate_right),
      Exercise(
          'Hanging knee raises', '4 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Ab wheel rollouts', '3 sets x 10 reps', Icons.sync),
      Exercise('Weighted sit-ups', '4 sets x 12 reps', Icons.fitness_center),
    ],
  ),
];

class DayGainWorkoutScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayGainWorkoutScreen(
      {super.key, this.day = 1, this.title = 'Cardio + Core'});

  @override
  State<DayGainWorkoutScreen> createState() => _DayGainWorkoutScreenState();
}

class _DayGainWorkoutScreenState extends State<DayGainWorkoutScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];
  int get _total => 1 + _plan.core.length; // one cardio choice + all core moves
  int get _completed => _done.length;
  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  // Cardio is "pick one", so it counts as a single task.
  void _toggleCardio(String name) => setState(() {
    if (_done.contains('cardio:$name')) {
      _done.remove('cardio:$name');
    } else {
      _done.removeWhere((e) => e.startsWith('cardio:'));
      _done.add('cardio:$name');
    }
  });

  void _toggleCore(String name) => setState(() {
    final key = 'core:$name';
    _done.contains(key) ? _done.remove(key) : _done.add(key);
  });

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    final finished = _completed >= _total;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: _bg,
        elevation: 0,
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
          Text('Your weight gain goal',
              style: t.titleSmall!.copyWith(color: _muted)),
          const SizedBox(height: 10),
          _goalSelector(t),
          const SizedBox(height: 20),
          _statsRow(t),
          const SizedBox(height: 24),
          _section(
            t,
            title: 'Warm-up',
            subtitle: '5 min',
            child: Text(
              'Arm circles, hip rotations and a slow walk. Get your heart rate up gently before you start.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cardio',
            subtitle: '${_plan.cardioMin} min  |  pick one',
            note: _plan.cardioNote,
            child: Column(
              children: _plan.cardio
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('cardio:${e.title}'),
                      () => _toggleCardio(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Core',
            subtitle: '${_plan.coreMin} min  |  rest 45 sec between sets',
            child: Column(
              children: _plan.core
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('core:${e.title}'),
                      () => _toggleCore(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk, then stretch your hamstrings, hips and lower back. Hold each stretch for 20 seconds.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _tips(t),
          const SizedBox(height: 24),
          _quote(t),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.asset("assets/images/workGym.png")),
          )
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
                Navigator.pop(context, true); // schedule marks it done
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                disabledBackgroundColor: const Color(0xFF222222),
                foregroundColor: Colors.black,
                disabledForegroundColor: _muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                finished
                    ? 'Complete Day ${widget.day}'
                    : '$_completed of $_total done',
                style: t.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: finished ? Colors.black : _muted),
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
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weight Gain', style: t.bodySmall!.copyWith(color: _muted)),
                const SizedBox(height: 2),
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
                    valueColor: const AlwaysStoppedAnimation(_orange),
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
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(_orange),
                  ),
                ),
                Text('${(_progress * 100).round()}%',
                    style: t.titleSmall!
                        .copyWith(color: _text, fontWeight: FontWeight.w600)),
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
                color: selected ? _text : _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? _text : Colors.white12),
              ),
              child: Column(
                children: [
                  Text(_plans[i].label,
                      style: t.titleSmall!.copyWith(
                          color: selected ? Colors.black : _text,
                          fontWeight: FontWeight.w600)),
                  Text(_plans[i].intensity,
                      style: t.bodySmall!.copyWith(
                          color: selected ? Colors.black54 : _muted)),
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
            Icon(icon, color: _text, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: t.titleMedium!
                    .copyWith(color: _text, fontWeight: FontWeight.w600)),
            Text(label, style: t.bodySmall!.copyWith(color: _muted)),
          ],
        ),
      ),
    );

    final total = _plan.cardioMin + _plan.coreMin + 10;
    return Row(
      children: [
        stat(Icons.timer_outlined, '$total min', 'Total'),
        const SizedBox(width: 10),
        stat(Icons.restaurant_outlined, '+${_plan.kcalSurplus}', 'kcal surplus'),
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
      decoration:
      BoxDecoration(color: _card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: _orange, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(title,
                  style: t.titleMedium!
                      .copyWith(color: _text, fontWeight: FontWeight.w700)),
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
            Text(note, style: t.bodySmall!.copyWith(color: _muted, height: 1.4)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _exerciseTile(
      TextTheme t, Exercise e, bool done, VoidCallback onTap) {
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
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(e.icon, color: done ? _muted : _text, size: 22),
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
                  Text(e.detail, style: t.bodySmall!.copyWith(color: _muted)),
                ],
              ),
            ),
            Icon(done ? Icons.check_circle : Icons.circle_outlined,
                color: done ? _orange : Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _tips(TextTheme t) {
    const tips = [
      'Drink 2-3 litres of water today.',
      'Eat about 250-500 kcal above your daily need.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
      'A safe pace is about 0.25-0.5 kg per week.',
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
              const Icon(Icons.check, color: _orange, size: 18),
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
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Don't run from your dream, chase the dream.",
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}