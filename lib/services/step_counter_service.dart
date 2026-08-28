import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepCounterService {
  StreamSubscription<StepCount>? _stepSubscription;

  void startStepCounter(Function(int steps) onSteps) {
    _stepSubscription = Pedometer.stepCountStream.listen(
          (StepCount event) {
        onSteps(event.steps);
      },
      onError: (error) {
        print("Step counter error: $error");
      },
    );
  }

  void stopStepCounter() {
    _stepSubscription?.cancel();
  }
}