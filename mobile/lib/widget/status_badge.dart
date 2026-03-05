import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;

  const StatusBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.layer2,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.spaceGrotesk(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
class StatStrip extends StatelessWidget {
  final List<({String label, String value})> stats;

  const StatStrip({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 36, color: AppColors.borderMuted),
            Expanded(
              child: Column(
                children: [
                  Text(
                    stats[i].value,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textMain,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats[i].label.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
