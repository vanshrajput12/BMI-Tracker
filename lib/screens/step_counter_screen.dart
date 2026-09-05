import 'package:bmi_project/services/step_counter_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../services/streak_count_service.dart';

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
  final StreakService _streakService = StreakService();

  int _steps = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();

    _loadStreak();
    _startStepCounter();
  }

  Future<void> _loadStreak() async {
    final streak = await _streakService.getStreak();

    if (!mounted) return;

    setState(() {
      _streak = streak;
    });
  }

  void _startStepCounter() {
    _stepCounterService.startStepCounter((steps) async {
      if (!mounted) return;

      setState(() {
        _steps = steps;
      });

      final streak = await _streakService.updateStreak(steps);

      if (!mounted) return;

      setState(() {
        _streak = streak;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,

        // 🔥 STREAK
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🔥',
                style: TextStyle(
                  fontSize: 21,
                ),
              ),

              const SizedBox(width: 3),

              Text(
                '$_streak',
                style: GoogleFonts.poppins(
                  color: Colors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        title: Column(
          children: [
            Text(
              'STEPS COUNTER',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            SizedBox(
              width: 190,
              child: Divider(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // LOTTIE ANIMATION
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

              // STEP COUNT
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
                    padding: const EdgeInsets.only(
                      bottom: 15,
                    ),
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

              const SizedBox(height: 14),

              // CALORIES CARD
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

              const SizedBox(height: 10),

              // DAILY GOAL CARD
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

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

                      duration: const Duration(
                        milliseconds: 500,
                      ),

                      curve: Curves.easeInOut,

                      builder: (
                          context,
                          value,
                          child,
                          ) {
                        return ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),

                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 10,
                            backgroundColor: Colors.white12,

                            valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
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

              const SizedBox(height: 10),

              // STREAK CARD
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: _cardColor,
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(
              //       color: _borderColor,
              //     ),
              //   ),
              //
              //   child: Row(
              //     children: [
              //       Container(
              //         height: 55,
              //         width: 55,
              //         decoration: BoxDecoration(
              //           color: Colors.orange.withOpacity(0.12),
              //           shape: BoxShape.circle,
              //         ),
              //
              //         child: const Center(
              //           child: Text(
              //             '🔥',
              //             style: TextStyle(
              //               fontSize: 28,
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //       const SizedBox(width: 15),
              //
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment:
              //           CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'Daily Streak',
              //               style: GoogleFonts.poppins(
              //                 color: Colors.white,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //
              //             const SizedBox(height: 3),
              //
              //             Text(
              //               _streak == 0
              //                   ? 'Walk 100 steps to start your streak'
              //                   : 'Keep walking every day!',
              //               style: GoogleFonts.poppins(
              //                 color: Colors.white54,
              //                 fontSize: 11,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       Text(
              //         '$_streak',
              //         style: GoogleFonts.poppins(
              //           color: Colors.orange,
              //           fontSize: 28,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //
              //       const SizedBox(width: 4),
              //
              //       Text(
              //         'days',
              //         style: GoogleFonts.poppins(
              //           color: Colors.white54,
              //           fontSize: 11,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}