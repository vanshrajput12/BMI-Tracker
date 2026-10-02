import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepCounterService {
  StreamSubscription<StepCount>? _stepSubscription;

  void startStepCounter(Function(int steps) onSteps) {
    _stepSubscription?.cancel();

    _stepSubscription = Pedometer.stepCountStream.listen(
          (StepCount event) {
        print("STEP COUNT: ${event.steps}");
        onSteps(event.steps);
      },
      onError: (error) {
        print("STEP COUNTER ERROR: $error");
      },
      cancelOnError: false,
    );
  }

  Future<void> stopStepCounter() async {
    await _stepSubscription?.cancel();
    _stepSubscription = null;
  }
}