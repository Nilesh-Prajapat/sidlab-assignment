import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/auth_service.dart';
import '../../utils/theme/colors.dart';
import '../../utils/validator.dart';
import '../../widget/app_input.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/section_header.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // ── local toggles (persisted to prefs in a real app) ──
  bool _analyticsEnabled    = false;
  bool _crashReporting      = true;

  String _stripHtml(String input) => input
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  void _showResultDialog({required bool success, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.layer1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: success
                    ? Colors.green.withOpacity(.12)
                    : Colors.redAccent.withOpacity(.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                success ? Icons.check_rounded : Icons.error_outline_rounded,
                size: 16,
                color: success ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              success ? 'Password Updated' : 'Update Failed',
              style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textMain,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(message,
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMuted, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              success ? 'Done' : 'Try Again',
              style: GoogleFonts.spaceGrotesk(
                color: success ? AppColors.textMain : Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changePasswordSheet() {
    final oldCtrl   = TextEditingController();
    final newCtrl   = TextEditingController();
    final formKey   = GlobalKey<FormState>();
    bool loading    = false;
    bool obscureOld = true;
    bool obscureNew = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.topBar,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (_, setSheet) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(sheetCtx).viewInsets.bottom + 32),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.layer2,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.lock_reset_outlined,
                              size: 18, color: AppColors.textMuted),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Change Password',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textMain,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text('Choose a strong, unique password',
                                  style: GoogleFonts.spaceGrotesk(
                                      color: AppColors.textDim, fontSize: 11)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(sheetCtx),
                          child: Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.layer2,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 16, color: AppColors.textDead),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 14, color: AppColors.textDead),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Use at least 6 characters. Mix letters, numbers and symbols.',
                              style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.textDim,
                                  fontSize: 11,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    AppInput(
                      label: 'Current Password',
                      placeholder: 'Enter current password',
                      obscure: obscureOld,
                      controller: oldCtrl,
                      validator: Validators.password,
                      suffix: IconButton(
                        icon: Icon(
                          obscureOld
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18, color: AppColors.textDead,
                        ),
                        onPressed: () =>
                            setSheet(() => obscureOld = !obscureOld),
                      ),
                    ),

                    const SizedBox(height: 14),

                    AppInput(
                      label: 'New Password',
                      placeholder: 'Enter new password',
                      obscure: obscureNew,
                      controller: newCtrl,
                      validator: Validators.password,
                      suffix: IconButton(
                        icon: Icon(
                          obscureNew
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18, color: AppColors.textDead,
                        ),
                        onPressed: () =>
                            setSheet(() => obscureNew = !obscureNew),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textMain,
                          foregroundColor: AppColors.base,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: loading
                            ? null
                            : () async {
                          if (!formKey.currentState!.validate()) return;
                          setSheet(() => loading = true);
                          try {
                            await AuthService().changePassword(
                              oldPassword: oldCtrl.text.trim(),
                              newPassword: newCtrl.text.trim(),
                            );
                            if (context.mounted) {
                              Navigator.pop(sheetCtx);
                              _showResultDialog(
                                success: true,
                                message:
                                'Your password has been updated successfully.',
                              );
                            }
                          } catch (e) {
                            setSheet(() => loading = false);
                            if (sheetCtx.mounted) {
                              final raw = e
                                  .toString()
                                  .replaceFirst('Exception: ', '');
                              _showResultDialog(
                                success: false,
                                message: _stripHtml(raw),
                              );
                            }
                          }
                        },
                        child: loading
                            ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.base))
                            : Text('Update Password',
                            style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.layer1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Data & Privacy',
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMain, fontWeight: FontWeight.w600)),
        content: Text(
          'TaskFlow stores your tasks and account info on our servers. '
              'We don\'t sell your data. Your password is hashed and never stored in plain text. '
              'You can delete your account at any time from Personal Info.',
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMuted, fontSize: 13, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it',
                style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textMain, fontWeight: FontWeight.w500)),
          ),
        ],
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
            title: 'Privacy & Security',
            subtitle: 'Your data & account',
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

                    /// ── SECURITY ────────────────────────────
                    const SectionHeader(title: 'Security'),
                    const SizedBox(height: 8),
                    _SettingsGroup(items: [
                      _SettingsItem(
                        icon: Icons.lock_reset_outlined,
                        label: 'Change Password',
                        subtitle: 'Update your login password',
                        onTap: _changePasswordSheet,
                      ),
                    ]),

                    const SizedBox(height: 20),

                    /// ── PRIVACY ─────────────────────────────
                    const SectionHeader(title: 'Privacy'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Column(
                        children: [
                          _SwitchItem(
                            icon: Icons.bar_chart_rounded,
                            label: 'Usage Analytics',
                            subtitle: 'Help improve the app',
                            value: _analyticsEnabled,
                            onChanged: (v) =>
                                setState(() => _analyticsEnabled = v),
                          ),
                          const Divider(height: 1, indent: 48),
                          _SwitchItem(
                            icon: Icons.bug_report_outlined,
                            label: 'Crash Reporting',
                            subtitle: 'Send crash logs automatically',
                            value: _crashReporting,
                            onChanged: (v) =>
                                setState(() => _crashReporting = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ── DATA ────────────────────────────────
                    const SectionHeader(title: 'Data'),
                    const SizedBox(height: 8),
                    _SettingsGroup(items: [
                      _SettingsItem(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        subtitle: 'How we handle your data',
                        onTap: _showPrivacyInfo,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    /// ── INFO BANNER ──────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined,
                              size: 16, color: AppColors.textDead),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your password is hashed and never stored in plain text. '
                                  'We don\'t share your data with third parties.',
                              style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.textDim,
                                  fontSize: 11,
                                  height: 1.6),
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

// ── SHARED WIDGETS ────────────────────────────────────────────

class _SettingsItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

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
          final i    = e.key;
          final item = e.value;
          return Column(
            children: [
              if (i > 0) const Divider(height: 1, indent: 48),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 15),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: AppColors.textDim),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label,
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textMain, fontSize: 14)),
                            Text(item.subtitle,
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textDim, fontSize: 11)),
                          ],
                        ),
                      ),
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

class _SwitchItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

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