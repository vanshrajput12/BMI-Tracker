import 'dart:math' as math;
import 'package:flutter/material.dart';

class BmiGauge extends StatelessWidget {
  final double bmi;

  const BmiGauge({
    super.key,
    required this.bmi,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 200,
      child: CustomPaint(
        painter: BmiGaugePainter(bmi: bmi),
      ),
    );
  }
}

class BmiGaugePainter extends CustomPainter {
  final double bmi;

  BmiGaugePainter({
    required this.bmi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height,
    );

    final radius = size.width / 2 - 10;

    final bands = [
      GaugeBand(
        15,
        18.5,
        const Color(0xFF378ADD),
      ),
      GaugeBand(
        18.5,
        25,
        const Color(0xFF63C922),
      ),
      GaugeBand(
        25,
        30,
        const Color(0xFFEF9F27),
      ),
      GaugeBand(
        30,
        40,
        const Color(0xFFE24B4A),
      ),
    ];

    const minBmi = 15.0;
    const maxBmi = 40.0;

    for (final band in bands) {
      final startAngle = _angleForBmi(
        band.start,
        minBmi,
        maxBmi,
      );

      final endAngle = _angleForBmi(
        band.end,
        minBmi,
        maxBmi,
      );

      final paint = Paint()
        ..color = band.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }

    final clampedBmi = bmi.clamp(
      minBmi,
      maxBmi,
    );

    final needleAngle = _angleForBmi(
      clampedBmi,
      minBmi,
      maxBmi,
    );

    final needleEnd = Offset(
      center.dx +
          (radius - 20) * math.cos(needleAngle),
      center.dy +
          (radius - 20) * math.sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      needleEnd,
      needlePaint,
    );

    canvas.drawCircle(
      center,
      5,
      Paint()..color = Colors.white,
    );
  }

  double _angleForBmi(
      double value,
      double min,
      double max,
      ) {
    final fraction = ((value - min) / (max - min))
        .clamp(0.0, 1.0);

    return math.pi + fraction * math.pi;
  }

  @override
  bool shouldRepaint(
      covariant BmiGaugePainter oldDelegate,
      ) {
    return oldDelegate.bmi != bmi;
  }
}

class GaugeBand {
  final double start;
  final double end;
  final Color color;

  const GaugeBand(
      this.start,
      this.end,
      this.color,
      );
}