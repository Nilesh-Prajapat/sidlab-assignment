import 'package:flutter/material.dart';
import '../utils/theme/colors.dart';

class AppTopBar extends StatefulWidget {

  final String title;
  final String? subtitle;
  final Widget? trailing;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 42, 20, 10),
          color: AppColors.topBar,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),

                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),

                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDim,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (widget.trailing != null)
                widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}