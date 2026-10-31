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
  final int upperMin;
  final int lowerMin;
  final int coreMin;
  final int kcalSurplus;
  final String note;
  final String rest;
  final List<Exercise> upper;
  final List<Exercise> lower;
  final List<Exercise> core;
  const GainPlan({
    required this.label,
    required this.intensity,
    required this.upperMin,
    required this.lowerMin,
    required this.coreMin,
    required this.kcalSurplus,
    required this.note,
    required this.rest,
    required this.upper,
    required this.lower,
    required this.core,
  });
}

const _plans = <GainPlan>[
  // 1 - 2 kg : bodyweight + light dumbbells
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    upperMin: 12,
    lowerMin: 12,
    coreMin: 6,
    kcalSurplus: 250,
    rest: 'rest 60 sec between sets',
    note: 'Use light dumbbells. Focus on clean form, not heavy weight.',
    upper: [
      Exercise('Push-ups', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Dumbbell shoulder press', '3 sets x 10 reps', Icons.arrow_upward),
      Exercise('Dumbbell rows', '3 sets x 10 reps', Icons.sync),
    ],
    lower: [
      Exercise('Bodyweight squats', '3 sets x 12 reps', Icons.arrow_downward),
      Exercise('Glute bridge', '3 sets x 12 reps', Icons.airline_seat_flat),
      Exercise('Lunges', '3 sets x 10 reps each leg', Icons.directions_walk),
    ],
    core: [
      Exercise('Plank', '3 sets x 30 sec', Icons.accessibility_new),
      Exercise('Dead bug', '3 sets x 10 reps', Icons.airline_seat_flat),
    ],
  ),
  // 3 - 4 kg : dumbbells, more sets
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    upperMin: 15,
    lowerMin: 15,
    coreMin: 10,
    kcalSurplus: 400,
    rest: 'rest 75 sec between sets',
    note: 'Pick a weight where the last 2 reps feel hard but your form holds.',
    upper: [
      Exercise('Push-ups', '4 sets x 12 reps', Icons.fitness_center),
      Exercise('Dumbbell shoulder press', '4 sets x 10 reps', Icons.arrow_upward),
      Exercise('One-arm dumbbell row', '4 sets x 10 reps each arm', Icons.sync),
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
    ],
    lower: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Romanian deadlift', '4 sets x 10 reps', Icons.arrow_upward),
      Exercise('Walking lunges', '3 sets x 12 reps each leg', Icons.directions_walk),
      Exercise('Calf raises', '3 sets x 15 reps', Icons.height),
    ],
    core: [
      Exercise('Plank', '3 sets x 45 sec', Icons.accessibility_new),
      Exercise('Weighted crunches', '3 sets x 12 reps', Icons.fitness_center),
    ],
  ),
  // 5 kg : heavy compound lifts
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    upperMin: 18,
    lowerMin: 18,
    coreMin: 9,
    kcalSurplus: 500,
    rest: 'rest 90 sec between sets',
    note: 'Heavy sets, fewer reps. Use a spotter or safety bars for big lifts.',
    upper: [
      Exercise('Bench press', '4 sets x 8 reps', Icons.fitness_center),
      Exercise('Overhead press', '4 sets x 8 reps', Icons.arrow_upward),
      Exercise('Bent-over rows', '4 sets x 8 reps', Icons.sync),
      Exercise('Pull-ups or lat pulldown', '3 sets x 8 reps', Icons.expand_less),
      Exercise('Triceps dips', '3 sets x 10 reps', Icons.arrow_downward),
    ],
    lower: [
      Exercise('Barbell back squat', '4 sets x 8 reps', Icons.arrow_downward),
      Exercise('Deadlift', '4 sets x 6 reps', Icons.arrow_upward),
      Exercise('Bulgarian split squat', '3 sets x 8 reps each leg',
          Icons.directions_walk),
      Exercise('Calf raises', '4 sets x 12 reps', Icons.height),
    ],
    core: [
      Exercise('Weighted plank', '3 sets x 45 sec', Icons.accessibility_new),
      Exercise('Hanging knee raises', '3 sets x 12 reps', Icons.airline_seat_flat),
    ],
  ),
];

class DayGainStrengthScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayGainStrengthScreen(
      {super.key, this.day = 2, this.title = 'Full Strength Training'});

  @override
  State<DayGainStrengthScreen> createState() => _DayGainStrengthScreenState();
}

class _DayGainStrengthScreenState extends State<DayGainStrengthScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];
  int get _total => _plan.upper.length + _plan.lower.length + _plan.core.length;
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
              'Arm circles, shoulder rolls, bodyweight squats and a light walk. Warm every joint you are about to load.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _group(t, 'Upper body', '${_plan.upperMin} min  |  ${_plan.rest}',
              _plan.note, 'upper', _plan.upper),
          const SizedBox(height: 16),
          _group(t, 'Lower body', '${_plan.lowerMin} min  |  ${_plan.rest}',
              null, 'lower', _plan.lower),
          const SizedBox(height: 16),
          _group(t, 'Core', '${_plan.coreMin} min  |  rest 45 sec', null,
              'core', _plan.core),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk, then stretch your chest, shoulders, quads and hamstrings. Hold each stretch for 20 seconds.',
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

  // One exercise group (upper / lower / core).
  Widget _group(TextTheme t, String title, String subtitle, String? note,
      String prefix, List<Exercise> items) {
    return _section(
      t,
      title: title,
      subtitle: subtitle,
      note: note,
      child: Column(
        children: items
            .map((e) => _exerciseTile(t, e, _done.contains('$prefix:${e.title}'),
                () => _toggle('$prefix:${e.title}')))
            .toList(),
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

    final total = _plan.upperMin + _plan.lowerMin + _plan.coreMin + 10;
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
      'Add a little weight or one more rep each week. That is what builds muscle.',
      'Sleep 7-9 hours. Muscles grow while you rest.',
      'Never skip form for weight. Lower the load if your technique breaks.',
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
              "Strong today, stronger tomorrow.",
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}