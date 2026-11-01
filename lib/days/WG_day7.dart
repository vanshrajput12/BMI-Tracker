// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF000000);
const _card = Color(0xFF151515);
const _orange = Color(0xFFFF9800); // accent only
const _text = Color(0xFFFFFFFF);
const _muted = Color(0xFF9E9E9E);

class RestItem {
  final String title;
  final String detail;
  final IconData icon;
  const RestItem(this.title, this.detail, this.icon);
}

const _checklist = <RestItem>[
  RestItem('Eat 3 full meals + 2 snacks', 'Stay in your calorie surplus today',
      Icons.restaurant_outlined),
  RestItem('Protein with every meal', 'Eggs, dal, paneer, chicken or curd',
      Icons.egg_outlined),
  RestItem('Drink 2-3 litres of water', 'Keep a bottle with you',
      Icons.water_drop_outlined),
  RestItem('Sleep 8-9 hours tonight', 'Muscles grow while you sleep',
      Icons.bedtime_outlined),
];

const _optional = <RestItem>[
  RestItem('Easy walk', '15-20 min, relaxed pace', Icons.directions_walk),
  RestItem('Full-body stretch', '10 min, slow and gentle', Icons.self_improvement),
  RestItem('Deep breathing', '5 min, inhale 4 sec, exhale 6 sec',
      Icons.spa_outlined),
];

class DayGainRestScreen extends StatefulWidget {
  final int day;
  final String title;
  const DayGainRestScreen({super.key, this.day = 7, this.title = 'Rest Day'});

  @override
  State<DayGainRestScreen> createState() => _DayGainRestScreenState();
}

class _DayGainRestScreenState extends State<DayGainRestScreen> {
  final Set<String> _done = {};

  int get _total => _checklist.length + _optional.length;
  int get _completed => _done.length;
  double get _progress =>
      _total == 0 ? 0 : (_completed / _total).clamp(0.0, 1.0);

  void _toggle(String key) => setState(() {
    _done.contains(key) ? _done.remove(key) : _done.add(key);
  });

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

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
          _statsRow(t),
          const SizedBox(height: 24),
          _section(
            t,
            title: 'Why rest matters',
            subtitle: '',
            child: Text(
              'Your muscles do not grow in the gym. They grow while you recover. Today your body repairs the work from this week, so take it easy and eat well.',
              style: t.bodyMedium!.copyWith(color: _muted, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Recovery checklist',
            subtitle: 'important',
            child: Column(
              children: _checklist
                  .map((e) => _tile(t, e, _done.contains('rec:${e.title}'),
                      () => _toggle('rec:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _section(
            t,
            title: 'Gentle movement',
            subtitle: 'optional',
            note: 'Keep it easy. If you feel very tired, skip these.',
            child: Column(
              children: _optional
                  .map((e) => _tile(t, e, _done.contains('opt:${e.title}'),
                      () => _toggle('opt:${e.title}')))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _meals(t),
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
              // A rest day can always be completed. The checklist is a guide.
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Day ${widget.day} complete!')));
                // TODO: save progress to Firestore here.
                Navigator.pop(context, true); // schedule marks it done
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Complete Day ${widget.day}',
                style: t.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black),
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

    return Row(
      children: [
        stat(Icons.bedtime_outlined, '8-9 hrs', 'Sleep'),
        const SizedBox(width: 10),
        stat(Icons.restaurant_outlined, '+250-500', 'kcal surplus'),
        const SizedBox(width: 10),
        stat(Icons.bolt_outlined, 'Rest', 'Level'),
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

  Widget _tile(TextTheme t, RestItem e, bool done, VoidCallback onTap) {
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

  Widget _meals(TextTheme t) {
    const meals = [
      ['Breakfast', 'Paneer or egg paratha, curd and a banana'],
      ['Lunch', 'Rice or roti, dal, vegetables and chicken or paneer'],
      ['Snack', 'Banana shake with peanut butter, or a handful of nuts'],
      ['Dinner', 'Roti, dal or chicken curry, salad and a glass of milk'],
    ];
    return _section(
      t,
      title: 'Sample meals',
      subtitle: 'ideas only',
      child: Column(
        children: meals
            .map((m) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 84,
                child: Text(m[0],
                    style: t.bodyMedium!.copyWith(
                        color: _text, fontWeight: FontWeight.w600)),
              ),
              Expanded(
                child: Text(m[1],
                    style: t.bodyMedium!
                        .copyWith(color: _muted, height: 1.4)),
              ),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget _tips(TextTheme t) {
    const tips = [
      'Do not train hard today. A real rest day makes next week stronger.',
      'Soreness is normal. Sharp or lasting pain is not. See a doctor if it continues.',
      'Weigh yourself at the same time each week, not every day.',
      'Plan your meals for the coming week so you do not miss your surplus.',
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
          const Icon(Icons.bedtime_outlined, color: _orange, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Rest today. Come back stronger.',
              style: t.titleMedium!
                  .copyWith(color: _text, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}