import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;
  final double size;

  const InitialsAvatar({super.key, required this.name, this.size = 36});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.layer2,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: GoogleFonts.spaceGrotesk(
          color: AppColors.textMuted,
          fontSize: size * 0.33,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
