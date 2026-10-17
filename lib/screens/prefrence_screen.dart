// pubspec.yaml -> dependencies: google_fonts: ^6.2.1
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Mostly amber. Red appears only as a slight tint in the top card gradient.
const _bg = Color(0xFF121212);
const _surface = Color(0xFF1C1C1E);
const _line = Color(0x14FFFFFF);
const _text = Color(0xFFEDEAF2);
const _muted = Color(0xFF9A98A3);
const _amber = Color(0xFFFFB400);
const _onAmber = Color(0xFF1A1205);
const _redTint = Color(0xFF3A1815);

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Units
  int _weightUnit = 0; // 0 = kg, 1 = lb
  int _heightUnit = 0; // 0 = cm, 1 = ft

  // Workout
  int _goal = 0; // 0 = 1-2 kg, 1 = 3-4 kg, 2 = 5 kg
  double _stepGoal = 8000;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 7, minute: 0);

  // Notifications
  bool _workoutReminder = true;
  bool _waterReminder = false;
  bool _weeklySummary = true;

  // App
  bool _haptics = true;
  bool _keepAwake = true;

  bool _changed = false;

  void _update(VoidCallback fn) => setState(() {
    fn();
    _changed = true;
  });

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _amber,
            onPrimary: _onAmber,
            surface: _surface,
            onSurface: _text,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) _update(() => _reminderTime = picked);
  }

  void _save() {
    // TODO: save these values to Firestore (for example users/{uid}/preferences).
    setState(() => _changed = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preferences saved')));
  }

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        title: Text(
          'Preferences',
          style: t.titleLarge!.copyWith(
            color: _text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _banner(t),
          const SizedBox(height: 24),
          _sectionTitle(t, Icons.straighten_rounded, 'Units'),
          _card([
            _segmentRow(
              t,
              'Weight',
              ['kg', 'lb'],
              _weightUnit,
              (i) => _update(() => _weightUnit = i),
            ),
            _divider(),
            _segmentRow(
              t,
              'Height',
              ['cm', 'ft'],
              _heightUnit,
              (i) => _update(() => _heightUnit = i),
            ),
          ]),
          const SizedBox(height: 24),
          _sectionTitle(t, Icons.flag_outlined, 'Workout'),
          _card([
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight loss goal',
                    style: t.bodyLarge!.copyWith(color: _text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Changes the intensity of your daily plan',
                    style: t.bodySmall!.copyWith(color: _muted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(3, (i) {
                      const labels = ['1-2 kg', '3-4 kg', '5 kg'];
                      final sel = i == _goal;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _update(() => _goal = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(right: i == 2 ? 0 : 10),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: sel
                                  ? _amber.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: sel
                                    ? _amber.withOpacity(0.6)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              labels[i],
                              style: t.titleSmall!.copyWith(
                                color: sel ? _amber : _text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            _divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Daily step goal',
                        style: t.bodyLarge!.copyWith(color: _text),
                      ),
                      const Spacer(),
                      Text(
                        '${_stepGoal.round()} steps',
                        style: t.bodyMedium!.copyWith(
                          color: _amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _amber,
                      inactiveTrackColor: Colors.white12,
                      thumbColor: Colors.white,
                      overlayColor: _amber.withOpacity(0.15),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _stepGoal,
                      min: 3000,
                      max: 15000,
                      divisions: 24,
                      onChanged: (v) => _update(() => _stepGoal = v),
                    ),
                  ),
                ],
              ),
            ),
            _divider(),
            _navRow(
              t,
              Icons.schedule_rounded,
              'Workout reminder time',
              _reminderTime.format(context),
              _pickTime,
            ),
          ]),
          const SizedBox(height: 24),
          _sectionTitle(t, Icons.notifications_none_rounded, 'Notifications'),
          _card([
            _switchRow(
              t,
              'Workout reminder',
              'A daily nudge at your set time',
              _workoutReminder,
              (v) => _update(() => _workoutReminder = v),
            ),
            _divider(),
            _switchRow(
              t,
              'Water reminder',
              'Reminders to drink water',
              _waterReminder,
              (v) => _update(() => _waterReminder = v),
            ),
            _divider(),
            _switchRow(
              t,
              'Weekly summary',
              'Your progress every Sunday',
              _weeklySummary,
              (v) => _update(() => _weeklySummary = v),
            ),
          ]),
          const SizedBox(height: 24),
          _sectionTitle(t, Icons.tune_rounded, 'App'),
          _card([
            _switchRow(
              t,
              'Haptic feedback',
              'Small vibrations when you tap',
              _haptics,
              (v) => _update(() => _haptics = v),
            ),
            _divider(),
            _switchRow(
              t,
              'Keep screen on',
              'While you are in a workout',
              _keepAwake,
              (v) => _update(() => _keepAwake = v),
            ),
          ]),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _changed ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                // foregroundColor: const Color(0xFF111113),
                // disabledBackgroundColor: const Color(0xFF2A2A2D),
                // disabledForegroundColor: _muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Save changes',
                style: t.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- building blocks ----------

  Widget _banner(TextTheme t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2812), _redTint, Color(0xFF1C1C1E)],
          stops: [0.0, 0.45, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune_rounded, color: _amber, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make it yours',
                  style: t.titleMedium!.copyWith(
                    color: _text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Units, goals and reminders',
                  style: t.bodySmall!.copyWith(color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(TextTheme t, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _amber),
          const SizedBox(width: 8),
          Text(
            title,
            style: t.titleMedium!.copyWith(
              color: _amber,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 1,
    color: _line,
    indent: 16,
    endIndent: 16,
  );

  Widget _segmentRow(
    TextTheme t,
    String label,
    List<String> options,
    int selected,
    ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(label, style: t.bodyLarge!.copyWith(color: _text)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(options.length, (i) {
                final sel = i == selected;
                return GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? _amber : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      options[i],
                      style: t.bodyMedium!.copyWith(
                        color: sel ? _onAmber : _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(
    TextTheme t,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyLarge!.copyWith(color: _text)),
                const SizedBox(height: 2),
                Text(subtitle, style: t.bodySmall!.copyWith(color: _muted)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A1A1C),
            activeTrackColor: Colors.white,
            inactiveThumbColor: _muted,
            inactiveTrackColor: Colors.white12,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _navRow(
    TextTheme t,
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: _muted, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: t.bodyLarge!.copyWith(color: _text)),
            ),
            Text(
              value,
              style: t.bodyMedium!.copyWith(
                color: _amber,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: _muted),
          ],
        ),
      ),
    );
  }
}
