import 'package:bmi_project/services/step_counter_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {

  static const Color _backgroundColor = Color(0xFF111111);
  static const Color _cardColor = Color(0xFF151515);
  static const Color _borderColor = Color(0xFF292929);

  final StepCounterService _stepCounterService = StepCounterService();

  int _steps = 0;

  void _startStepCounter() {
    _stepCounterService.startStepCounter((steps) {
      if (!mounted) return;

      setState(() {
        _steps = steps;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startStepCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            110,
          ),

          child: Column(
            children: [
              Text(
                'STEPS COUNTER',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                width: 190,
                child: Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 250,
                width: 250,
                child: Lottie.asset(
                  "assets/animations/Indonesia maju.json",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 15),
              Text(
                "Steps Today",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_steps',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      '/ 10,000',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _borderColor,
                  ),
                ),

                child: Column(
                  children: [
                    Text(
                      "Total Calories Burned",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${(_steps * 0.04).toStringAsFixed(0)} kcal",
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      "Estimated calories burned today",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _borderColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Goal",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          '${((_steps / 10000) * 100).clamp(0, 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            color: Colors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: (_steps / 10000).clamp(0.0, 1.0),
                      ),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 10,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${_steps.clamp(0, 10000)} / 10,000 steps",
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}