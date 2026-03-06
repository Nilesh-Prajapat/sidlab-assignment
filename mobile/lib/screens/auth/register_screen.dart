import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../api_service/auth_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../utils/validator.dart';
import '../../widget/app_button.dart';
import '../../widget/app_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name     = TextEditingController();
  final _email    = TextEditingController();
  final _petName  = TextEditingController();
  final _password = TextEditingController();
  final _confirm  = TextEditingController();
  bool _obscure1  = true;
  bool _obscure2  = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _petName.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message,
                  style: GoogleFonts.spaceGrotesk(color: AppColors.textMain)),
              backgroundColor: AppColors.layer2,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0, right: -10,
                    child: Text('Join',
                        style: GoogleFonts.spaceGrotesk(
                            color: AppColors.layer2, fontSize: 120,
                            fontWeight: FontWeight.w700, height: 1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,
                              color: AppColors.textDim, size: 22),
                        ),
                        const SizedBox(height: 32),
                        Text('Create account.',
                            style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textMain, fontSize: 30,
                                fontWeight: FontWeight.w600, letterSpacing: -0.5)),
                        const SizedBox(height: 6),
                        Text('Join Taskflow to manage your projects.',
                            style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDim, fontSize: 15)),
                        const SizedBox(height: 36),
                        AppInput(
                          label: 'Name',
                          placeholder: 'Enter your full name',
                          controller: _name,
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'Email',
                          placeholder: 'you@example.com',
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'Pet Name',
                          placeholder: 'Your pet\'s name (for password recovery)',
                          controller: _petName,
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'Password',
                          placeholder: 'Create a strong password',
                          controller: _password,
                          obscure: _obscure1,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure1 = !_obscure1),
                            child: Icon(
                              _obscure1
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textDead, size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'Confirm Password',
                          placeholder: 'Confirm your password',
                          controller: _confirm,
                          obscure: _obscure2,
                          suffix: GestureDetector(
                            onTap: () => setState(() => _obscure2 = !_obscure2),
                            child: Icon(
                              _obscure2
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textDead, size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        AppButton(
                          label: loading ? 'Creating...' : 'Create account',
                          onTap: loading
                              ? null
                              : () {
                            final err =
                                Validators.name(_name.text) ??
                                    Validators.email(_email.text) ??
                                    (_petName.text.trim().isEmpty
                                        ? 'Pet name is required'
                                        : null) ??
                                    Validators.password(_password.text) ??
                                    Validators.confirmPassword(
                                        _confirm.text, _password.text);
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(err,
                                      style: GoogleFonts.spaceGrotesk(
                                          color: AppColors.textMain)),
                                  backgroundColor: AppColors.layer2,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              AuthRegisterRequested(
                                name: _name.text.trim(),
                                email: _email.text.trim(),
                                petName: _petName.text.trim(),
                                password: _password.text,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text('Back to sign in',
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textDim, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDead, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}