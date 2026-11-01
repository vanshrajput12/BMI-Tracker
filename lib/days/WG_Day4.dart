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
  final int hiitMin;
  final int finisherMin;
  final int kcalSurplus;
  final String hiitPattern; // work / rest / rounds
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
  // 1 - 2 kg : short bursts, long rests
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    hiitMin: 20,
    finisherMin: 10,
    kcalSurplus: 250,
    hiitPattern: '30 sec work / 60 sec rest x 3 rounds',
    hiitNote: 'Go hard for the short burst, then rest fully. Rest is part of the plan.',
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
  // 3 - 4 kg : more rounds, weighted moves
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    hiitMin: 25,
    finisherMin: 15,
    kcalSurplus: 400,
    hiitPattern: '40 sec work / 50 sec rest x 4 rounds',
    hiitNote: 'Hard effort, but keep your form clean. Stop a set if it breaks down.',
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
  // 5 kg : heavier power work, full rests
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    hiitMin: 30,
    finisherMin: 15,
    kcalSurplus: 500,
    hiitPattern: '40 sec work / 60 sec rest x 4 rounds',
    hiitNote: 'Explosive reps with real rest. Keep the weight light enough to move fast.',
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
  const DayGainHiitScreen({super.key, this.day = 4, this.title = 'HIIT'});

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

  void _toggle(String key) => setState(() {
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
              'Jumping jacks, arm circles, bodyweight squats and leg swings. HIIT is explosive, so warm up properly.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'HIIT circuit',
            subtitle: '${_plan.hiitMin} min',
            note: '${_plan.hiitPattern}\n${_plan.hiitNote}',
            child: Column(
              children: _plan.hiit
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('hiit:${e.title}'),
                      () => _toggle('hiit:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Strength finisher',
            subtitle: '${_plan.finisherMin} min  |  rest 60 sec',
            note: _plan.finisherNote,
            child: Column(
              children: _plan.finisher
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('fin:${e.title}'),
                      () => _toggle('fin:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk until your breathing settles, then stretch your quads, hamstrings and shoulders. Hold each stretch for 20 seconds.',
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

    final total = _plan.hiitMin + _plan.finisherMin + 10;
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
      'Eat a small carb snack 1 hour before: banana, oats or toast with peanut butter.',
      'Have protein and carbs within 1-2 hours after: eggs with rice, paneer or dal.',
      'Do not shorten the rests. Full rest keeps your power high and protects your muscle.',
      'Drink 2-3 litres of water. You will sweat more on HIIT days.',
      'Stop and rest if you feel dizzy or sharp pain. Never push through it.',
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
          const Icon(Icons.bolt, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Short bursts. Full effort. Full rest.',
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}