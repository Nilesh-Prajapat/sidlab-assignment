import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(
      {super.key, required this.title, this.action, this.onAction});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.textDim,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.5,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.textDead,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ),
      ],
    );
  }
}
