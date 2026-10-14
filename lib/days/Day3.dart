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
  final int cardioMin;
  final int stretchMin;
  final int kcal; // rough estimate only
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
  // 1 - 2 kg
  _GoalPlan(
    label: '1-2 kg',
    intensity: 'Easy',
    cardioMin: 30,
    stretchMin: 10,
    kcal: 220,
    cardioNote: 'Keep a steady pace. You should be able to talk while moving.',
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
  // 3 - 4 kg
  _GoalPlan(
    label: '3-4 kg',
    intensity: 'Medium',
    cardioMin: 35,
    stretchMin: 10,
    kcal: 330,
    cardioNote: 'Warm up 5 min, then alternate 3 min fast + 1 min easy.',
    stretchNote: 'Hold each stretch 30 sec, 2 rounds. Breathe slowly.',
    cardio: [
      _Exercise('Jogging intervals', '35 min, 3 min fast + 1 min easy',
          Icons.directions_run),
      _Exercise('Or dancing', '35 min, high energy', Icons.music_note),
      _Exercise('Or power walk', '35 min, add hills or stairs',
          Icons.directions_walk),
    ],
    stretches: [
      _Exercise('Hamstring stretch', '30 sec each leg x 2', Icons.self_improvement),
      _Exercise('Quadriceps stretch', '30 sec each leg x 2', Icons.self_improvement),
      _Exercise('Shoulder and chest stretch', '30 sec x 2', Icons.self_improvement),
      _Exercise('Hip flexor stretch', '30 sec each side x 2', Icons.self_improvement),
      _Exercise('Calf stretch', '30 sec each leg x 2', Icons.self_improvement),
    ],
  ),
  // 5 kg
  _GoalPlan(
    label: '5 kg',
    intensity: 'Hard',
    cardioMin: 45,
    stretchMin: 12,
    kcal: 450,
    cardioNote: 'Warm up 5 min, then alternate 2 min hard + 1 min easy.',
    stretchNote: 'Hold each stretch 30 sec, 3 rounds. Breathe slowly.',
    cardio: [
      _Exercise('Jogging / running intervals', '45 min, 2 min hard + 1 min easy',
          Icons.directions_run),
      _Exercise('Or dance workout', '45 min, high intensity', Icons.music_note),
      _Exercise('Or incline power walk', '45 min, fast with hills',
          Icons.directions_walk),
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
  const DayFlexibilityScreen(
      {super.key, this.day = 3, this.title = 'Cardio + Flexibility'});

  @override
  State<DayFlexibilityScreen> createState() => _DayFlexibilityScreenState();
}

class _DayFlexibilityScreenState extends State<DayFlexibilityScreen> {
  int _goal = 0;
  final Set<String> _done = {};

  _GoalPlan get _plan => _plans[_goal];
  // Cardio is "pick one", so it counts as one task.
  int get _total => 1 + _plan.stretches.length;
  int get _completed => _done.length;
  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggleCardio(String name) => setState(() {
    if (_done.contains('cardio:$name')) {
      _done.remove('cardio:$name');
    } else {
      _done.removeWhere((e) => e.startsWith('cardio:'));
      _done.add('cardio:$name');
    }
  });

  void _toggleStretch(String name) => setState(() {
    final key = 'stretch:$name';
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
            title: 'Flexibility & stretching',
            subtitle: '${_plan.stretchMin} min',
            note: _plan.stretchNote,
            child: Column(
              children: _plan.stretches
                  .map((e) => _exerciseTile(
                  t, e, _done.contains('stretch:${e.title}'),
                      () => _toggleStretch(e.title)))
                  .toList(),
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
                child: Image.asset("assets/images/stretching.png")),
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

    final total = _plan.cardioMin + _plan.stretchMin;
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
              Flexible(
                flex: 3,
                child: Text(title,
                    style: t.titleMedium!
                        .copyWith(color: _red, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              Flexible(
                flex: 2,
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
      'Stretch when your muscles are warm, right after cardio.',
      'Go to a gentle pull, never to pain. Do not bounce.',
      'Drink 2-3 litres of water today.',
      'Good flexibility helps you recover and lowers injury risk on strength days.',
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
          const Icon(Icons.self_improvement, color: _amber, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Push harder than yesterday, if you want a different tomorrow.',
              style: t.titleMedium!
                  .copyWith(color: _amber, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}