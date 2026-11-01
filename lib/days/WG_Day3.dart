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
  // 1 - 2 kg : gentle, short
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 15,
    flexMin: 15,
    kcalSurplus: 250,
    cardioNote: 'Easy pace. This is active recovery, not a hard session.',
    flexNote: 'Move slowly. Stretch until you feel tension, never pain.',
    cardio: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    flex: [
      Exercise('Hamstring stretch', '3 x 20 sec each leg', Icons.self_improvement),
      Exercise('Quad stretch', '3 x 20 sec each leg', Icons.accessibility_new),
      Exercise("Child's pose", '3 x 30 sec', Icons.spa_outlined),
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
    ],
  ),
  // 3 - 4 kg : a bit longer, more stretches
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 20,
    flexMin: 20,
    kcalSurplus: 400,
    cardioNote: 'Steady and comfortable. Keep energy for tomorrow\'s lifting.',
    flexNote: 'Focus on the muscles you trained on Day 2.',
    cardio: [
      Exercise('Brisk walking', '20 min, steady pace', Icons.directions_walk),
      Exercise('Or cycling', '20 min, light to moderate', Icons.pedal_bike),
      Exercise('Or swimming', '20 min, easy laps', Icons.pool),
    ],
    flex: [
      Exercise('Hamstring stretch', '3 x 30 sec each leg', Icons.self_improvement),
      Exercise('Quad stretch', '3 x 30 sec each leg', Icons.accessibility_new),
      Exercise('Hip flexor stretch', '3 x 30 sec each side', Icons.airline_seat_flat),
      Exercise('Chest and shoulder stretch', '3 x 30 sec', Icons.expand_less),
      Exercise("Child's pose", '3 x 40 sec', Icons.spa_outlined),
    ],
  ),
  // 5 kg : longest mobility session
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 22,
    flexMin: 25,
    kcalSurplus: 500,
    cardioNote: 'Keep it light to moderate. Heavy lifting needs fresh legs.',
    flexNote: 'Longer holds help heavy-lifting recovery. Breathe slowly.',
    cardio: [
      Exercise('Brisk walking', '22 min, steady pace', Icons.directions_walk),
      Exercise('Or cycling', '22 min, light to moderate', Icons.pedal_bike),
      Exercise('Or swimming', '22 min, easy laps', Icons.pool),
    ],
    flex: [
      Exercise('Hamstring stretch', '3 x 40 sec each leg', Icons.self_improvement),
      Exercise('Quad stretch', '3 x 40 sec each leg', Icons.accessibility_new),
      Exercise('Hip flexor stretch', '3 x 40 sec each side', Icons.airline_seat_flat),
      Exercise('Chest and shoulder stretch', '3 x 40 sec', Icons.expand_less),
      Exercise('Spinal twist', '3 x 30 sec each side', Icons.rotate_right),
      Exercise("Child's pose", '3 x 45 sec', Icons.spa_outlined),
    ],
  ),
];

class DayFlexibilityScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayFlexibilityScreen(
      {super.key, this.day = 3, this.title = 'Cardio + Flexibility'});

  @override
  State<DayFlexibilityScreen> createState() => _DayFlexibilityScreenState();
}

class _DayFlexibilityScreenState extends State<DayFlexibilityScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];
  int get _total => 1 + _plan.flex.length; // one cardio choice + all stretches
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

  void _toggleFlex(String name) => setState(() {
    final key = 'flex:$name';
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
              'Arm circles, hip rotations and a slow walk. Get your body moving gently before you start.',
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
            title: 'Flexibility',
            subtitle: '${_plan.flexMin} min  |  hold, do not bounce',
            note: _plan.flexNote,
            child: Column(
              children: _plan.flex
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('flex:${e.title}'),
                      () => _toggleFlex(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk and deep breathing. Inhale for 4 seconds, exhale for 6 seconds, and let your heart rate settle.',
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

    final total = _plan.cardioMin + _plan.flexMin + 10;
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
              const SizedBox(width: 10),
              Expanded(
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
      'Keep eating in a surplus even on lighter days. Recovery needs fuel.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Stretching improves your range of motion, which helps your lifts.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
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
          const Icon(Icons.self_improvement, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Rest and recovery build the strength.',
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}