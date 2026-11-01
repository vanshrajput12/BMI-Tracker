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
  // 1 - 2 kg : very light, mostly recovery
  GainPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    activityMin: 15,
    strengthMin: 15,
    mobilityMin: 15,
    kcalSurplus: 250,
    activityNote: 'Very easy pace. You should feel better after, not tired.',
    strengthNote: 'Bodyweight only. Slow reps, stop 3 reps before failure.',
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
      Exercise('Hamstring stretch', '2 x 30 sec each leg', Icons.self_improvement),
      Exercise('Hip flexor stretch', '2 x 30 sec each side', Icons.airline_seat_flat),
    ],
  ),
  // 3 - 4 kg : light weights, steady recovery
  GainPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    activityMin: 15,
    strengthMin: 20,
    mobilityMin: 15,
    kcalSurplus: 400,
    activityNote: 'Easy and steady. Keep your heart rate low.',
    strengthNote: 'Light dumbbells, about half of your normal working weight.',
    activity: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    strength: [
      Exercise('Goblet squats', '3 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell rows', '3 sets x 10 reps each arm', Icons.sync),
      Exercise('Dumbbell shoulder press', '3 sets x 10 reps', Icons.expand_less),
      Exercise('Romanian deadlift', '3 sets x 10 reps', Icons.arrow_upward),
      Exercise('Plank', '3 sets x 40 sec', Icons.accessibility_new),
    ],
    mobility: [
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
      Exercise("Child's pose", '3 x 40 sec', Icons.spa_outlined),
      Exercise('Hamstring stretch', '3 x 30 sec each leg', Icons.self_improvement),
      Exercise('Chest and shoulder stretch', '3 x 30 sec', Icons.expand_less),
    ],
  ),
  // 5 kg : light-moderate lifts, longest session
  GainPlan(
    label: '5 kg',
    intensity: 'Hard',
    activityMin: 15,
    strengthMin: 25,
    mobilityMin: 15,
    kcalSurplus: 500,
    activityNote: 'Keep it easy. Today you recover so tomorrow you grow.',
    strengthNote: 'Moderate weight, controlled reps. Not a max-effort day.',
    activity: [
      Exercise('Easy walking', '15 min, relaxed pace', Icons.directions_walk),
      Exercise('Or cycling', '15 min, light resistance', Icons.pedal_bike),
      Exercise('Or swimming', '15 min, easy laps', Icons.pool),
    ],
    strength: [
      Exercise('Goblet squats', '4 sets x 10 reps', Icons.arrow_downward),
      Exercise('Dumbbell bench press', '3 sets x 10 reps', Icons.fitness_center),
      Exercise('Dumbbell rows', '3 sets x 10 reps each arm', Icons.sync),
      Exercise('Romanian deadlift', '3 sets x 10 reps', Icons.arrow_upward),
      Exercise('Biceps curls', '3 sets x 12 reps', Icons.fitness_center),
      Exercise('Weighted plank', '3 sets x 40 sec', Icons.accessibility_new),
    ],
    mobility: [
      Exercise('Cat-cow', '10 slow reps', Icons.sync),
      Exercise("Child's pose", '3 x 45 sec', Icons.spa_outlined),
      Exercise('Hamstring stretch', '3 x 40 sec each leg', Icons.self_improvement),
      Exercise('Hip flexor stretch', '3 x 40 sec each side', Icons.airline_seat_flat),
      Exercise('Spinal twist', '3 x 30 sec each side', Icons.rotate_right),
    ],
  ),
];

class DayGainRecoveryScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayGainRecoveryScreen(
      {super.key, this.day = 6, this.title = 'Recovery + Strength'});

  @override
  State<DayGainRecoveryScreen> createState() => _DayGainRecoveryScreenState();
}

class _DayGainRecoveryScreenState extends State<DayGainRecoveryScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  GainPlan get _plan => _plans[_goal];
  // one light-activity choice + all strength moves + all mobility moves
  int get _total => 1 + _plan.strength.length + _plan.mobility.length;
  int get _completed => _done.length;
  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  // Light activity is "pick one", so it counts as a single task.
  void _toggleActivity(String name) => setState(() {
    if (_done.contains('act:$name')) {
      _done.remove('act:$name');
    } else {
      _done.removeWhere((e) => e.startsWith('act:'));
      _done.add('act:$name');
    }
  });

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
              'Arm circles, hip rotations and a slow walk. Move gently and let your body loosen up.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Light activity',
            subtitle: '${_plan.activityMin} min  |  pick one',
            note: _plan.activityNote,
            child: Column(
              children: _plan.activity
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('act:${e.title}'),
                      () => _toggleActivity(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Light strength',
            subtitle: '${_plan.strengthMin} min  |  rest 60 sec',
            note: _plan.strengthNote,
            child: Column(
              children: _plan.strength
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('str:${e.title}'),
                      () => _toggle('str:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Mobility',
            subtitle: '${_plan.mobilityMin} min  |  hold, do not bounce',
            note: 'Stretch until you feel tension, never pain. Breathe slowly.',
            child: Column(
              children: _plan.mobility
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('mob:${e.title}'),
                      () => _toggle('mob:${e.title}')))
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

    final total =
        _plan.activityMin + _plan.strengthMin + _plan.mobilityMin + 10;
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
      'Keep eating in a surplus today. Recovery days are when your body builds.',
      'Have protein with every meal: eggs, dal, paneer, chicken or curd.',
      'Drink 2-3 litres of water to help your muscles recover.',
      'If you feel very sore, choose the lighter option and skip extra sets.',
      'Sleep 7-9 hours. Tomorrow is your rest day, so finish the week strong.',
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
          const Icon(Icons.spa_outlined, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Recovery is part of the training.',
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}