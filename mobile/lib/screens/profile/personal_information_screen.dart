import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/auth_bloc.dart';
import '../../api_service/auth_service.dart';
import '../../utils/theme/colors.dart';
import '../../utils/validator.dart';
import '../../widget/app_input.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/avatar.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _deleting   = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      _nameCtrl.text  = state.user['name']  ?? '';
      _emailCtrl.text = state.user['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.spaceGrotesk(color: AppColors.textMain)),
        backgroundColor: AppColors.layer2,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteAccount() async {
    setState(() => _deleting = true);
    try {
      await AuthService().deleteAccount();
      if (!mounted) return;
      context.read<AuthBloc>().add(AuthLogoutRequested());
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.layer1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete account',
            style: GoogleFonts.spaceGrotesk(color: AppColors.textMain)),
        content: Text(
          'This will permanently delete your account and all tasks. '
              'This action cannot be undone.',
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.spaceGrotesk(color: AppColors.textDim)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: Text('Delete',
                style: GoogleFonts.spaceGrotesk(color: Colors.redAccent)),
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
            title: 'Personal Info',
            subtitle: 'Edit your details',
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              clipBehavior: Clip.antiAlias,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final name = state is AuthAuthenticated
                      ? state.user['name'] ?? ''
                      : '';
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(child: InitialsAvatar(name: name, size: 72)),

                        const SizedBox(height: 28),

                        AppInput(
                          label: 'Full Name',
                          placeholder: 'Your name',
                          controller: _nameCtrl,
                          validator: Validators.name,
                        ),

                        const SizedBox(height: 16),

                        AppInput(
                          label: 'Email Address',
                          placeholder: 'you@example.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),

                        const SizedBox(height: 28),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.layer1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.red.withOpacity(.18)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _deleting
                                ? null
                                : () => _confirmDelete(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  _deleting
                                      ? const SizedBox(
                                    width: 18, height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.redAccent,
                                    ),
                                  )
                                      : const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _deleting
                                        ? 'Deleting account...'
                                        : 'Delete account',
                                    style: GoogleFonts.spaceGrotesk(
                                        color: Colors.redAccent, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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