import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/app_button.dart';

enum AppThemeMode { dark, amoled, dim }

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  AppThemeMode _theme    = AppThemeMode.dark;
  double _fontSize       = 14;
  double _borderRadius   = 8;
  bool _reduceMotion     = false;
  bool _compactMode      = false;

  final _themes = [
    _ThemeOption(
      mode: AppThemeMode.dark,
      name: 'Dark',
      description: 'Default — #101010 base',
      colors: [Color(0xFF101010), Color(0xFF161616)],
    ),
    _ThemeOption(
      mode: AppThemeMode.amoled,
      name: 'AMOLED',
      description: 'True black — saves battery',
      colors: [Color(0xFF000000), Color(0xFF0A0A0A)],
    ),
    _ThemeOption(
      mode: AppThemeMode.dim,
      name: 'Dim',
      description: 'Softer dark for long sessions',
      colors: [Color(0xFF1A1C1E), Color(0xFF232527)],
    ),
  ];

  void _apply() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appearance updated',
          style: GoogleFonts.spaceGrotesk(color: AppColors.textMain),
        ),
        backgroundColor: AppColors.layer2,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.topBar,
      body: Column(
        children: [
          const AppTopBar(
            title: 'Appearance',
            subtitle: 'Customize your view',
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ── DEMO BANNER ───────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 15, color: AppColors.textDim),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This is a demo — settings are not applied yet.',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDim,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ── THEME ────────────────────────────
                    _GroupLabel('THEME'),
                    const SizedBox(height: 10),
                    ..._themes.map((opt) => _ThemeCard(
                      option: opt,
                      selected: _theme == opt.mode,
                      onTap: () => setState(() => _theme = opt.mode),
                    )),

                    const SizedBox(height: 20),

                    /// ── FONT SIZE ─────────────────────────
                    _GroupLabel('FONT SIZE'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Size',
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textMain, fontSize: 14),
                              ),
                              Text(
                                '${_fontSize.round()}px',
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textDead, fontSize: 13),
                              ),
                            ],
                          ),
                          Slider(
                            value: _fontSize,
                            min: 12,
                            max: 18,
                            divisions: 6,
                            activeColor: AppColors.textMain,
                            inactiveColor: AppColors.layer2,
                            onChanged: (v) => setState(() => _fontSize = v),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Aa',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textDead, fontSize: 11)),
                              Text('Aa',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textDim, fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ── BORDER RADIUS ─────────────────────
                    _GroupLabel('BORDER RADIUS'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Radius',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textMain, fontSize: 14)),
                              Text('${_borderRadius.round()}px',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textDead, fontSize: 13)),
                            ],
                          ),
                          Slider(
                            value: _borderRadius,
                            min: 0,
                            max: 20,
                            divisions: 20,
                            activeColor: AppColors.textMain,
                            inactiveColor: AppColors.layer2,
                            onChanged: (v) => setState(() => _borderRadius = v),
                          ),
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.layer2,
                              borderRadius:
                              BorderRadius.circular(_borderRadius),
                              border: Border.all(color: AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'PREVIEW',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDead,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ── LAYOUT ─────────────────────────────
                    _GroupLabel('LAYOUT'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Column(
                        children: [
                          _SwitchTile(
                            icon: Icons.motion_photos_off_outlined,
                            label: 'Reduce Motion',
                            subtitle: 'Fewer animations',
                            value: _reduceMotion,
                            onChanged: (v) =>
                                setState(() => _reduceMotion = v),
                          ),
                          const Divider(height: 1, indent: 48),
                          _SwitchTile(
                            icon: Icons.view_compact_outlined,
                            label: 'Compact Mode',
                            subtitle: 'Smaller task tiles',
                            value: _compactMode,
                            onChanged: (v) =>
                                setState(() => _compactMode = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    AppButton(label: 'Apply changes', onTap: _apply),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SUB-WIDGETS ───────────────────────────────────────────────

class _ThemeOption {
  final AppThemeMode mode;
  final String name;
  final String description;
  final List<Color> colors;
  const _ThemeOption(
      {required this.mode,
        required this.name,
        required this.description,
        required this.colors});
}

class _ThemeCard extends StatelessWidget {
  final _ThemeOption option;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeCard(
      {required this.option, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.layer1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.textMuted : AppColors.borderMuted,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                    colors: option.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                border: Border.all(color: AppColors.border),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.name,
                      style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(option.description,
                      style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textDim, fontSize: 11)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded,
                  size: 16, color: AppColors.textMain),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile(
      {required this.icon,
        required this.label,
        required this.subtitle,
        required this.value,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textDim),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textMain, fontSize: 14)),
                Text(subtitle,
                    style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textDim, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.textMain,
            activeTrackColor: AppColors.textDead,
            inactiveThumbColor: AppColors.textDead,
            inactiveTrackColor: AppColors.layer2,
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.spaceGrotesk(
      color: AppColors.textDim,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
    ),
  );
}