import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme/colors.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscure;
  final TextEditingController? controller;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const AppInput({
    super.key,
    required this.label,
    required this.placeholder,
    this.obscure = false,
    this.controller,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.textDim,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMain, fontSize: 15, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}