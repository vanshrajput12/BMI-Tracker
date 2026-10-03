import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterService {
  StreamSubscription<StepCount>? _stepSubscription;

  static const String _dateKey = 'step_counter_date';
  static const String _baselineKey = 'step_counter_baseline';

  void startStepCounter(Function(int steps) onSteps) async {
    await _stepSubscription?.cancel();

    _stepSubscription = Pedometer.stepCountStream.listen(
          (StepCount event) async {
        final rawSteps = event.steps;

        print("RAW STEP COUNT: $rawSteps");

        final prefs = await SharedPreferences.getInstance();

        // Today's date
        final today = _getTodayKey();

        // Date stored from previous session
        final savedDate = prefs.getString(_dateKey);

        // Starting step count for today
        int? baseline = prefs.getInt(_baselineKey);

        // ------------------------------------------------
        // NEW DAY
        // ------------------------------------------------
        if (savedDate != today || baseline == null) {
          baseline = rawSteps;

          await prefs.setString(_dateKey, today);
          await prefs.setInt(_baselineKey, baseline);

          print("NEW DAY DETECTED");
          print("New baseline: $baseline");

          // Start today's counter from ZERO
          onSteps(0);

          return;
        }

        // ------------------------------------------------
        // HANDLE DEVICE PEDOMETER RESET
        // ------------------------------------------------
        if (rawSteps < baseline) {
          baseline = rawSteps;

          await prefs.setInt(_baselineKey, baseline);

          print("PEDOMETER RESET DETECTED");
          print("New baseline: $baseline");

          onSteps(0);

          return;
        }

        // ------------------------------------------------
        // TODAY'S STEPS
        // ------------------------------------------------
        final todaySteps = rawSteps - baseline;

        print("TODAY'S STEPS: $todaySteps");

        onSteps(todaySteps);
      },

      onError: (error) {
        print("STEP COUNTER ERROR: $error");
      },

      cancelOnError: false,
    );
  }

  String _getTodayKey() {
    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> stopStepCounter() async {
    await _stepSubscription?.cancel();
    _stepSubscription = null;
  }
}