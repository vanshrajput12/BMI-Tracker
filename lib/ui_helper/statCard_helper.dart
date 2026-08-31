import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  static const Color _cardColor = Color(0xFF151515);
  static const Color _borderColor = Color(0xFF292929);
  final IconData icon;
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.label,
    required this.value, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: _borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(icon, color: Colors.white70, size: 19),
          ),

          const SizedBox(height: 14),

          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}