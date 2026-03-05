import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api_service/auth_bloc.dart';
import '../utils/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minTimeDone = false;
  AuthState? _pendingState;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _minTimeDone = true;
      if (_pendingState != null) _navigate(_pendingState!);
    });
  }

  void _navigate(AuthState state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is AuthUnauthenticated) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          if (_minTimeDone) {
            _navigate(state);
          } else {
            _pendingState = state;
          }
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'TASKFLOW',
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMain,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 6,
              ),
            ),
            const Spacer(),
            const LinearProgressIndicator(
              backgroundColor: AppColors.layer2,
              valueColor:  const AlwaysStoppedAnimation<Color>(AppColors.textMain),
              minHeight: 1,
            ),
          ],
        ),
      ),
    );
  }
}