// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _red = Color(0xFFFF4D3D);
const _amber = Color(0xFFFFB400);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);

class _Item {
  final String title;
  final String detail;
  final IconData icon;
  const _Item(this.title, this.detail, this.icon);
}

const _habits = <_Item>[
  _Item('Drink enough water', '2-3 litres through the day', Icons.water_drop_outlined),
  _Item('Eat a balanced meal', 'Protein, vegetables and whole grains', Icons.restaurant_outlined),
  _Item('Sleep well tonight', '7-8 hours', Icons.bedtime_outlined),
];

const _optional = <_Item>[
  _Item('Light stretching', '10-15 min, gentle and slow', Icons.self_improvement),
  _Item('Easy walk', '20-30 min, relaxed pace', Icons.directions_walk),
];

class DayRestScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayRestScreen({super.key, this.day = 7, this.title = 'Rest Day'});

  @override
  State<DayRestScreen> createState() => _DayRestScreenState();
}

class _DayRestScreenState extends State<DayRestScreen> {
  final Set<String> _done = {};

  int get _habitsDone => _habits.where((h) => _done.contains(h.title)).length;
  double get _progress => _habitsDone / _habits.length;

  void _toggle(String key) => setState(() {
    _done.contains(key) ? _done.remove(key) : _done.add(key);
  });

  // Optional activity is "pick one".
  void _toggleOptional(String key) => setState(() {
    if (_done.contains(key)) {
      _done.remove(key);
    } else {
      for (final o in _optional) {
        _done.remove(o.title);
      }
      _done.add(key);
    }
  });

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

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
          _message(t),
          const SizedBox(height: 24),
          _section(
            t,
            title: 'Rest day checklist',
            subtitle: '$_habitsDone of ${_habits.length}',
            child: Column(
              children: _habits
                  .map((e) => _tile(
                  t, e, _done.contains(e.title), () => _toggle(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'If you feel active',
            subtitle: 'optional  |  pick one',
            note: 'Keep it gentle. Today is about recovery, not effort.',
            child: Column(
              children: _optional
                  .map((e) => _tile(t, e, _done.contains(e.title),
                      () => _toggleOptional(e.title)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _tips(t),
          const SizedBox(height: 24),
          _thankYou(t),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.asset("assets/images/thank-you.png")),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Day ${widget.day} complete!')));
                // TODO: save progress to Firestore here.
                Navigator.maybePop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Complete Day ${widget.day}',
                  style: t.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white)),
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

  Widget _message(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bedtime_outlined, color: _amber, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "It's important to let your body recover. If you feel active, try light stretching or a 20-30 minute walk.",
              style: t.bodyLarge!.copyWith(
                  color: _amber, fontWeight: FontWeight.w600, height: 1.5),
            ),
          ),
        ],
      ),
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

  Widget _tile(TextTheme t, _Item e, bool done, VoidCallback onTap) {
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
      'Muscles grow and fat loss continues while you rest. Rest is part of the plan.',
      'A safe pace is about 0.5-1 kg per week. Weigh yourself at the same time each week.',
      'Plan your meals and workout time for next week today.',
      'Mild soreness is normal. If pain lasts more than a few days, see a doctor.',
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

  Widget _thankYou(TextTheme t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _amber.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_outlined, color: _amber, size: 36),
          const SizedBox(height: 10),
          Text('Thank you',
              style: t.headlineMedium!
                  .copyWith(color: _amber, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            'You finished a full week of training. See you next week!',
            textAlign: TextAlign.center,
            style: t.bodyMedium!.copyWith(color: _muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}