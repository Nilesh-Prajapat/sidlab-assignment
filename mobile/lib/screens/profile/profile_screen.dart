import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/auth_bloc.dart';
import '../../api_service/task_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/avatar.dart';
import '../../widget/status_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.topBar,

      body: Column(
        children: [

          const AppTopBar(
            title: "Profile",
            subtitle: "Manage your account",
          ),
          /// CONTENT CARD
          Expanded(
            child: Container(
              width: double.infinity,

              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),

              clipBehavior: Clip.antiAlias,

              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {

                  String name = "User";
                  String email = "";

                  if (authState is AuthAuthenticated) {
                    name = authState.user['name'] ?? "User";
                    email = authState.user['email'] ?? "";
                  }

                  return BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, taskState) {

                      int total = 0;
                      int done = 0;
                      int active = 0;

                      if (taskState is TaskLoaded) {
                        total = taskState.tasks.length;
                        done = taskState.tasks.where((t) => t['completed'] == true).length;
                        active = total - done;
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

                        child: Column(
                          children: [

                            const SizedBox(height: 10),

                            /// USER AVATAR
                            InitialsAvatar(name: name, size: 72),

                            const SizedBox(height: 14),

                            Text(
                              name,
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textMain,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              email,
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDim,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'TASKFLOW USER',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDead,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// STATS
                            StatStrip(
                              stats: [
                                (label: 'Done', value: done.toString()),
                                (label: 'Active', value: active.toString()),
                                (label: 'Total', value: total.toString()),
                              ],
                            ),

                            const SizedBox(height: 24),

                            /// SETTINGS GROUP 1
                            const _ActionGroup(items: [
                              _ActionItem(
                                icon: Icons.person_outline_rounded,
                                label: 'Personal Information',
                              ),
                              const _ActionItem(
                                icon: Icons.notifications_none_rounded,
                                label: 'Notifications',
                              ),
                              _ActionItem(
                                icon: Icons.palette_outlined,
                                label: 'Appearance',
                                trailing: 'Dark',
                              ),
                              _ActionItem(
                                icon: Icons.lock_outline_rounded,
                                label: 'Privacy & Security',
                              ),
                            ]),

                            const SizedBox(height: 12),

                            _ActionGroup(items: [
                              const _ActionItem(
                                icon: Icons.help_outline_rounded,
                                label: 'Help & Support',
                              ),
                              const _ActionItem(
                                icon: Icons.info_outline_rounded,
                                label: 'About',
                              ),

                              _ActionItem(
                                icon: Icons.logout_rounded,
                                label: 'Log Out',
                                labelColor: AppColors.textDim,
                                iconColor: AppColors.textDead,
                                onTap: () {

                                  context.read<AuthBloc>().add(AuthLogoutRequested());

                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                        (_) => false,
                                  );
                                },
                              ),
                            ]),

                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _ActionGroup extends StatelessWidget {
  final List<_ActionItem> items;

  const _ActionGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 48),
            items[i],
          ],
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? labelColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.labelColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelClr = labelColor ?? AppColors.textMain;
    final iconClr = iconColor ?? AppColors.textDim;

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [

            Icon(icon, color: iconClr, size: 18),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: labelClr,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            if (trailing != null)
              Text(
                trailing!,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textDead,
                  fontSize: 13,
                ),
              ),

            const SizedBox(width: 4),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textDead,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}