import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/avatar.dart';
import '../../widget/section_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _version  = 'v1.0.0';
  static const _devName  = 'Nilesh Prajapat';
  static const _devRole  = 'Diploma CSE → B.Tech CSE 2nd Year';
  static const _devBio   =
      'Diploma in CSE, now in B.Tech 2nd year. '
      'Into building mobile apps and backend stuff — Flutter and Node are my '
      'go-to. TaskFlow is a project I built for an internship assignment at SidLabs. '
      'I like keeping things clean, minimal, and actually working.';

  static const _githubUrl = 'https://github.com/Nilesh-Prajapat';
  static const _portfolio = 'https://itsnilesh.vercel.app';
  static const _email     = 'work.nilesh.pr@gmail.com';

  static const _stack = [
    'Flutter', 'Dart', 'Node.js', 'Express',
    'MongoDB', 'Git', 'Android Studio', 'IntelliJ IDEA',
  ];

  Future<void> _launch(BuildContext ctx, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Could not open link',
                style: GoogleFonts.spaceGrotesk(color: AppColors.textMain)),
            backgroundColor: AppColors.layer2,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _copy(BuildContext ctx, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Copied: $text',
            style: GoogleFonts.spaceGrotesk(color: AppColors.textMain)),
        backgroundColor: AppColors.layer2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.topBar,
      body: Column(
        children: [
          const AppTopBar(
            title: 'About',
            subtitle: 'The developer & the app',
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
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// DEV CARD
                    Center(
                      child: Column(
                        children: [
                          _TappableAvatar(name: _devName),
                          const SizedBox(height: 12),
                          Text(
                            _devName,
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textMain,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _devRole.toUpperCase(),
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textDead,
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BIO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Text(
                        _devBio,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.65,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TECH STACK
                    const SectionHeader(title: 'Tech Stack'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _stack.map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.layer1,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.borderMuted),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),

                    const SizedBox(height: 20),

                    /// FIND ME
                    const SectionHeader(title: 'Find Me'),
                    const SizedBox(height: 10),
                    _LinkGroup(items: [
                      _LinkItem(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        value: 'Nilesh-Prajapat',
                        onTap: () => _launch(context, _githubUrl),
                      ),
                      _LinkItem(
                        icon: Icons.language_rounded,
                        label: 'Portfolio',
                        value: 'itsnilesh.vercel.app',
                        onTap: () => _launch(context, _portfolio),
                      ),
                      _LinkItem(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: _email,
                        onTap: () => _copy(context, _email),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    /// APP INFO
                    const SectionHeader(title: 'App Info'),
                    const SizedBox(height: 10),
                    _LinkGroup(items: [
                      _LinkItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Version',
                        value: _version,
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 28),

                    /// FOOTER
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'BUILT WITH ♥ USING FLUTTER',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textDead,
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '© 2026 $_devName',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textDead,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
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

// ── EASTER EGG AVATAR ───────────────────────────────────────

class _TappableAvatar extends StatefulWidget {
  final String name;
  const _TappableAvatar({required this.name});

  @override
  State<_TappableAvatar> createState() => _TappableAvatarState();
}

class _TappableAvatarState extends State<_TappableAvatar> {
  int _taps = 0;

  void _onTap() {
    setState(() => _taps++);
    if (_taps == 2) {
      _taps = 0;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.layer1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          title: Text('👀 since you\'re here...',
              style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          content: Text(
            'I was already awake for 18 hours when the assignment mail landed.\n\n'
                'Stayed up from 3pm to 3am the next day to ship this.\n\n'
                'Worth it though.',
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMuted, fontSize: 13, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('respect 🫡',
                  style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: InitialsAvatar(name: widget.name, size: 72),
    );
  }
}

// ── HELPERS ─────────────────────────────────────────────────

class _LinkItem {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _LinkItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
}

class _LinkGroup extends StatelessWidget {
  final List<_LinkItem> items;
  const _LinkGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            children: [
              if (i > 0) const Divider(height: 1, indent: 48),
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: AppColors.textDim),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textMain, fontSize: 14),
                        ),
                      ),
                      Text(
                        item.value,
                        style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textDead, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: AppColors.textDead),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}