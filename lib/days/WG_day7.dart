
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1C1C1E);
const _orange = Color(0xFFFF8A24);
const _softOrange = Color(0xFFFFB366);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _border = Color(0xFF303034);
const _success = Color(0xFF55C98A);

class _Item {
  final String title;
  final String detail;
  final IconData icon;

  const _Item(this.title, this.detail, this.icon);
}

const _habits = <_Item>[
  _Item(
    'Drink enough water',
    '2-3 litres through the day',
    Icons.water_drop_outlined,
  ),
  _Item(
    'Eat a balanced meal',
    'Protein, vegetables and whole grains',
    Icons.restaurant_outlined,
  ),
  _Item(
    'Sleep well tonight',
    '7-8 hours',
    Icons.bedtime_outlined,
  ),
];

const _optional = <_Item>[
  _Item(
    'Light stretching',
    '10-15 min, gentle and slow',
    Icons.self_improvement,
  ),
  _Item(
    'Easy walk',
    '20-30 min, relaxed pace',
    Icons.directions_walk,
  ),
];

class DayGainRestScreen extends StatefulWidget {
  final int day;
  final String title;

  const DayGainRestScreen({
    super.key,
    this.day = 7,
    this.title = 'Rest Day',
  });

  @override
  State<DayGainRestScreen> createState() => _DayGainRestScreenState();
}

class _DayGainRestScreenState extends State<DayGainRestScreen> {
  final Set<String> _done = {};

  int get _habitsDone =>
      _habits.where((h) => _done.contains(h.title)).length;

  double get _progress => _habitsDone / _habits.length;

  void _toggle(String key) {
    setState(() {
      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        _done.add(key);
      }
    });
  }


  void _toggleOptional(String key) {
    setState(() {
      if (_done.contains(key)) {
        _done.remove(key);
      } else {
        for (final item in _optional) {
          _done.remove(item.title);
        }
        _done.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: _text),
        title: Text(
          'Day ${widget.day}',
          style: t.titleLarge?.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
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
            subtitle: '$_habitsDone of ${_habits.length} completed',
            icon: Icons.checklist_rounded,
            child: Column(
              children: _habits.map((e) {
                return _tile(
                  t,
                  e,
                  _done.contains(e.title),
                      () => _toggle(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _section(
            t,
            title: 'If you feel active',
            subtitle: 'Optional • Pick one',
            icon: Icons.directions_walk,
            note: 'Keep it gentle. Today is about recovery, not effort.',
            child: Column(
              children: _optional.map((e) {
                return _tile(
                  t,
                  e,
                  _done.contains(e.title),
                      () => _toggleOptional(e.title),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          _tips(t),
          const SizedBox(height: 20),

          _thankYou(t),
          const SizedBox(height: 10),

          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset(
                'assets/images/thank-you.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          decoration: BoxDecoration(
            color: _bg,
            border: Border(
              top: BorderSide(
                color: _border.withOpacity(0.6),
              ),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Day ${widget.day} complete!'),
                    backgroundColor: _card,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // TODO: Save progress to Firestore here.
                Navigator.maybePop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Complete Day ${widget.day}',
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Progress header
  Widget _header(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3A2417),
            Color(0xFF211B18),
            _card,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _orange.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEIGHT LOSS',
                  style: t.labelSmall?.copyWith(
                    color: _softOrange,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.title,
                  style: t.headlineSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),

                Text(
                  'Today\'s progress',
                  style: t.bodySmall?.copyWith(
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(_orange),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$_habitsDone / ${_habits.length} habits completed',
                  style: t.bodySmall?.copyWith(
                    color: _softOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(_orange),
                  ),
                ),
                Text(
                  '${(_progress * 100).round()}%',
                  style: t.titleSmall?.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Rest day message
  Widget _message(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _orange.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.13),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.bedtime_outlined,
              color: _orange,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time to recharge!',
                  style: t.titleMedium?.copyWith(
                    color: _softOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'It\'s important to let your body recover. '
                      'If you feel active, try light stretching '
                      'or a 20-30 minute walk.',
                  style: t.bodySmall?.copyWith(
                    color: _muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Common section card
  Widget _section(
      TextTheme t, {
        required String title,
        required String subtitle,
        required IconData icon,
        String? note,
        required Widget child,
      }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _orange.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: _orange,
                  size: 19,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.titleMedium?.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: t.bodySmall?.copyWith(
                          color: _softOrange,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          if (note != null) ...[
            const SizedBox(height: 12),
            Text(
              note,
              style: t.bodySmall?.copyWith(
                color: _muted,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Habit and activity tile
  Widget _tile(
      TextTheme t,
      _Item e,
      bool done,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 9,
        ),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: done
              ? _orange.withOpacity(0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: done
                    ? _success.withOpacity(0.13)
                    : _orange.withOpacity(0.13),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                e.icon,
                color: done ? _success : _orange,
                size: 22,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: t.bodyMedium?.copyWith(
                      color: done ? _muted : _text,
                      fontWeight: FontWeight.w600,
                      decoration: done
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    e.detail,
                    style: t.bodySmall?.copyWith(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              done
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: done ? _success : Colors.white24,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // Daily tips
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
      subtitle: 'Small habits, big results',
      icon: Icons.lightbulb_outline,
      child: Column(
        children: tips.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: _orange,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s,
                    style: t.bodySmall?.copyWith(
                      color: _muted,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Weekly completion message
  Widget _thankYou(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            _orange.withOpacity(0.13),
            _card,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: _orange,
              size: 32,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Thank you!',
            style: t.headlineMedium?.copyWith(
              color: _softOrange,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'You finished a full week of training. '
                'See you next week!',
            textAlign: TextAlign.center,
            style: t.bodyMedium?.copyWith(
              color: _muted,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'KEEP GOING',
              style: t.labelMedium?.copyWith(
                color: _orange,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
