
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weight_entry_model.dart';

class WeightHistoryChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightHistoryChart({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Your weight history will appear here.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: false,
          ),

          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,

                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 ||
                      index >= entries.length) {
                    return const SizedBox();
                  }

                  final date = entries[index].date;

                  if (date == null) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                    ),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0;
                i < entries.length;
                i++)
                  FlSpot(
                    i.toDouble(),
                    entries[i].weightKg,
                  ),
              ],

              isCurved: true,

              color: const Color(0xFFD35C15),

              barWidth: 2,

              dotData: const FlDotData(
                show: true,
              ),

              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFFD35C15)
                    .withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}