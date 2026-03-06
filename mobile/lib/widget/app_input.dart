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
  final String? Function(String?)? validator;

  const AppInput({
    super.key,
    required this.label,
    required this.placeholder,
    this.obscure = false,
    this.controller,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
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
        ],
        validator != null
            ? TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMain,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffix,
          ),
        )
            : TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMain,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}