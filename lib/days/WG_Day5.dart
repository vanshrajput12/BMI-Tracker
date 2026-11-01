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
  final int armsMin;
  final int legsMin;
  final int kcalSurplus;
  final String rest;
  final String armsNote;
  final String legsNote;
  final List<Exercise> arms;
  final List<Exercise> legs;
  const GainPlan({
    required this.label,
    required this.intensity,
    required this.armsMin,
    required this.legsMin,
    required this.kcalSurplus,
    required this.rest,
    required this.armsNote,
    required this.legsNote,
    required this.arms,
    required this.legs,
  });
}

const _plans = <GainPlan>[
  // 1 - 2 kg : light dumbbells, simple moves
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    armsMin: 15,
    legsMin: 15,
    kcalSurplus: 250,
    rest: 'rest 60 sec between sets',
    armsNote: 'Light dumbbells. Lift for 2 sec, lower for 3 sec.',
    legsNote: 'Bodyweight or light dumbbells. Keep your knees in line with your toes.',
    arms: [
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Triceps kickbacks', '3 sets x 12 reps', Icons.arrow_back),
      Exercise('Hammer curls', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Bench dips', '3 sets x 8 reps', Icons.arrow_downward),
    ],
    legs: [
      Exercise('Bodyweight squats', '3 sets x 15 reps', Icons.arrow_downward),
      Exercise('Reverse lunges', '3 sets x 10 reps each leg', Icons.directions_walk),
      Exercise('Glute bridge', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Calf raises', '3 sets x 15 reps', Icons.height),
    ],
  ),
  // 3 - 4 kg : moderate dumbbells, more volume
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    armsMin: 18,
    legsMin: 20,
    kcalSurplus: 400,
    rest: 'rest 75 sec between sets',
    armsNote: 'Moderate weight. The last 2 reps of each set should feel hard.',
    legsNote: 'Go deep on squats if your knees and hips allow it.',
    arms: [
      Exercise('Barbell or dumbbell curls', '4 sets x 10 reps', Icons.fitness_center),
      Exercise('Overhead triceps extension', '4 sets x 10 reps', Icons.arrow_upward),
      Exercise('Hammer curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Close-grip push-ups', '3 sets x 10 reps', Icons.accessibility_new),
      Exercise('Lateral raises', '3 sets x 12 reps', Icons.open_with),
    ],
    legs: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Romanian deadlift', '4 sets x 10 reps', Icons.arrow_upward),
      Exercise('Walking lunges', '3 sets x 12 reps each leg', Icons.directions_walk),
      Exercise('Step-ups', '3 sets x 10 reps each leg', Icons.stairs),
      Exercise('Calf raises', '4 sets x 15 reps', Icons.height),
    ],
  ),
  // 5 kg : heavy compound lifts
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    armsMin: 20,
    legsMin: 25,
    kcalSurplus: 500,
    rest: 'rest 90 sec between sets',
    armsNote: 'Heavier weights, strict form. No swinging the body.',
    legsNote: 'Heavy sets. Use a spotter or safety bars for squats.',
    arms: [
      Exercise('Barbell curls', '4 sets x 8 reps', Icons.fitness_center),
      Exercise('Skull crushers', '4 sets x 8 reps', Icons.arrow_upward),
      Exercise('Incline dumbbell curls', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Triceps dips', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Hammer curls', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Lateral raises', '3 sets x 12 reps', Icons.open_with),
    ],
    legs: [
      Exercise('Barbell back squat', '5 sets x 6 reps', Icons.arrow_downward),
      Exercise('Romanian deadlift', '4 sets x 8 reps', Icons.arrow_upward),
      Exercise('Leg press', '4 sets x 10 reps', Icons.airline_seat_legroom_extra),
      Exercise('Bulgarian split squat', '3 sets x 8 reps each leg',
          Icons.directions_walk),
      Exercise('Standing calf raises', '4 sets x 12 reps', Icons.height),
    ],
  ),
];

class DayGainStrengthTrainingScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayGainStrengthTrainingScreen(
      {super.key, this.day = 5, this.title = 'Strength Training'});

  @override
  State<DayGainStrengthTrainingScreen> createState() =>
      _DayGainStrengthTrainingScreenState();
}

class _DayGainStrengthTrainingScreenState extends State<DayGainStrengthTrainingScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];
  int get _total => _plan.arms.length + _plan.legs.length;
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
              'Arm circles, wrist rolls, bodyweight squats and leg swings. Do 1 light set of your first exercise before you load it.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Arms',
            subtitle: '${_plan.armsMin} min  |  ${_plan.rest}',
            note: _plan.armsNote,
            child: Column(
              children: _plan.arms
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('arms:${e.title}'),
                      () => _toggle('arms:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Legs',
            subtitle: '${_plan.legsMin} min  |  ${_plan.rest}',
            note: _plan.legsNote,
            child: Column(
              children: _plan.legs
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('legs:${e.title}'),
                      () => _toggle('legs:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk, then stretch your biceps, triceps, quads, hamstrings and calves. Hold each stretch for 20 seconds.',
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

    final total = _plan.armsMin + _plan.legsMin + 10;
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
      'Eat protein within 1-2 hours after training: eggs, paneer, dal, chicken or curd.',
      'Add 250-500 kcal above your daily need. Banana shake, peanut butter and nuts help.',
      'Try to add a little weight or one more rep than last week.',
      'Do not skip leg day. Big muscles help your whole body grow.',
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
          const Icon(Icons.fitness_center, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Small gains every week add up.',
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}