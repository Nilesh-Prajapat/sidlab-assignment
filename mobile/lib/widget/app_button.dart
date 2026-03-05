import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool secondary;
  final bool destructive;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.secondary = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: destructive
                ? Colors.transparent
                : secondary
                ? AppColors.layer1
                : AppColors.textMain,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: destructive
                  ? Colors.transparent
                  : secondary
                  ? AppColors.border
                  : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: destructive
                  ? AppColors.textDead
                  : secondary
                  ? AppColors.textMuted
                  : AppColors.base,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: destructive ? 0 : 0.5,
            ),
          ),
        ),
      ),
    );
  }
}