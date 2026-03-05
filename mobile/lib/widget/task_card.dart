import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskflow/widget/status_badge.dart';

import '../utils/theme/colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final String? priority;
  final bool done;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    this.priority,
    this.done = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.layer1,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderMuted),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // checkbox
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: _Checkbox(done: done),
            ),
            const SizedBox(width: 12),
            // content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      color: done ? AppColors.textDead : AppColors.textMain,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.textDead,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        date,
                        style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textDim, fontSize: 12),
                      ),
                      if (priority != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          priority!.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textDead,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            StatusBadge(status),
          ],
        ),
      ),
    );
  }
}
class _Checkbox extends StatelessWidget {
  final bool done;
  const _Checkbox({required this.done});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: done ? AppColors.textMain : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: done ? AppColors.textMain : AppColors.textDead,
          width: 1.5,
        ),
      ),
      child: done
          ?  const Icon(Icons.check, size: 11, color: AppColors.base)
          : null,
    );
  }
}