import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class PrioritySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Row(
        children: ['LOW', 'MEDIUM', 'HIGH'].map((p) {
          final active = p == selected.toUpperCase();
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: active ? AppColors.textMain : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  p,
                  style: GoogleFonts.spaceGrotesk(
                    color: active ? AppColors.base : AppColors.textDim,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
