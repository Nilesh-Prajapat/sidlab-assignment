import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/auth_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../utils/validator.dart';
import '../../widget/app_button.dart';
import '../../widget/app_input.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool _obscure   = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.layer2,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'TASKFLOW',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textDim,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Welcome back.',
                      style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textMain,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  Text('Sign in to your workspace.',
                      style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textDim, fontSize: 15)),
                  const SizedBox(height: 28),

                  /// DOT GRID BANNER
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.layer1,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderMuted),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: CustomPaint(painter: _DotGridPainter())),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.layer2,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.check,
                                color: AppColors.textMuted, size: 28),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  AppInput(
                    label: 'Email',
                    placeholder: 'user@example.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  AppInput(
                    label: 'Password',
                    placeholder: '••••••••',
                    obscure: _obscure,
                    controller: _password,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textDead,
                          size: 18),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()),
                      ),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textDim,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                    label: loading ? 'Signing in...' : 'Sign in',
                    onTap: loading
                        ? null
                        : () {
                      final emailErr = Validators.email(_email.text);
                      final passErr  = Validators.password(_password.text);
                      final err = emailErr ?? passErr;
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
                      context.read<AuthBloc>().add(AuthLoginRequested(
                        email:    _email.text.trim(),
                        password: _password.text,
                      ));
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 13, color: AppColors.textDim),
                          children: [
                            const TextSpan(text: "Don't have an account?  "),
                            TextSpan(
                                text: 'Create one',
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textMain,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF252525)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    const spacing = 20.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}