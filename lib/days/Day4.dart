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
  final int hiitMin;
  final int kcal; // rough estimate only
  final String hiitNote;
  final List<_Exercise> warmup;
  final List<_Exercise> hiit;
  const _GoalPlan({
    required this.label,
    required this.intensity,
    required this.warmupMin,
    required this.hiitMin,
    required this.kcal,
    required this.hiitNote,
    required this.warmup,
    required this.hiit,
  });
}

const _plans = <_GoalPlan>[
  // 1 - 2 kg
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    warmupMin: 5,
    hiitMin: 30,
    kcal: 300,
    hiitNote:
    'Do all 4 moves in a row as one round. Rest 1 min after each round and repeat 6 rounds.',
    warmup: [
      _Exercise('Light jumping', '5 min, easy skipping or small hops',
          Icons.arrow_upward),
      _Exercise('Or walking', '5 min, brisk pace', Icons.directions_walk),
    ],
    hiit: [
      _Exercise('Jumping squats', '6 rounds x 30 sec work, 30 sec rest',
          Icons.airline_seat_legroom_extra),
      _Exercise('Mountain climbers', '6 rounds x 30 sec work, 30 sec rest',
          Icons.terrain),
      _Exercise('Burpees (step-back, no jump)',
          '6 rounds x 30 sec work, 30 sec rest', Icons.fitness_center),
      _Exercise('Jumping jacks', '6 rounds x 30 sec work, 30 sec rest',
          Icons.accessibility_new),
    ],
  ),
  // 3 - 4 kg
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    warmupMin: 8,
    hiitMin: 35,
    kcal: 420,
    hiitNote:
    'Do all 4 moves in a row as one round. Rest 1 min after each round and repeat 7 rounds.',
    warmup: [
      _Exercise('Light jumping', '8 min, skipping or jumping jacks',
          Icons.arrow_upward),
      _Exercise('Or walking', '8 min, brisk pace', Icons.directions_walk),
    ],
    hiit: [
      _Exercise('Jumping squats', '7 rounds x 40 sec work, 20 sec rest',
          Icons.airline_seat_legroom_extra),
      _Exercise('Mountain climbers', '7 rounds x 40 sec work, 20 sec rest',
          Icons.terrain),
      _Exercise('Burpees', '7 rounds x 40 sec work, 20 sec rest',
          Icons.fitness_center),
      _Exercise('Jumping jacks', '7 rounds x 40 sec work, 20 sec rest',
          Icons.accessibility_new),
    ],
  ),
  // 5 kg
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    warmupMin: 10,
    hiitMin: 40,
    kcal: 560,
    hiitNote:
    'Do all 4 moves in a row as one round. Rest 1 min after each round and repeat 8 rounds. Slow down if your form breaks.',
    warmup: [
      _Exercise('Light jumping', '10 min, skipping and jumping jacks',
          Icons.arrow_upward),
      _Exercise('Or brisk walk / jog', '10 min, build up slowly',
          Icons.directions_run),
    ],
    hiit: [
      _Exercise('Jumping squats', '8 rounds x 45 sec work, 15 sec rest',
          Icons.airline_seat_legroom_extra),
      _Exercise('Mountain climbers', '8 rounds x 45 sec work, 15 sec rest',
          Icons.terrain),
      _Exercise('Burpees', '8 rounds x 45 sec work, 15 sec rest',
          Icons.fitness_center),
      _Exercise('Jumping jacks', '8 rounds x 45 sec work, 15 sec rest',
          Icons.accessibility_new),
    ],
  ),
];

class DayHiitScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayHiitScreen(
      {super.key,
        this.day = 4,
        this.title = 'HIIT (High-Intensity Interval Training)'});

  @override
  State<DayHiitScreen> createState() => _DayHiitScreenState();
}

class _DayHiitScreenState extends State<DayHiitScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];
  // Warm-up is "pick one", so it counts as one task.
  int get _total => 1 + _plan.hiit.length;
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

  void _toggleHiit(String name) => setState(() {
    final key = 'hiit:$name';
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
            note: 'Light cardio to get your heart rate up before the intervals.',
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
            title: 'HIIT workout',
            subtitle: '${_plan.hiitMin} min',
            note: _plan.hiitNote,
            child: Column(
              children: _plan.hiit
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('hiit:${e.title}'),
                      () => _toggleHiit(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Cool-down',
            subtitle: '5 min',
            child: Text(
              'Slow walk until your breathing settles, then stretch your legs, chest and shoulders. Sip water.',
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
                child: Image.asset("assets/images/workout2.png")),
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
                    style: t.titleLarge!
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

    final total = _plan.warmupMin + _plan.hiitMin + 5;
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
      'HIIT is intense. Stop and rest if you feel dizzy, sick or have chest pain.',
      'Land softly on the balls of your feet to protect your knees.',
      'Drink water before, during and after. You will sweat a lot.',
      'Do not do HIIT two days in a row. Your body needs time to recover.',
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
          const Icon(Icons.psychology_outlined, color: _amber, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Your mind is your strongest muscle.',
              style: t.titleMedium!
                  .copyWith(color: _amber, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}