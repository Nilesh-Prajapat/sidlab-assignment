import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/auth_service.dart';
import '../../utils/theme/colors.dart';
import '../../utils/validator.dart';
import '../../widget/app_button.dart';
import '../../widget/app_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _emailCtrl   = TextEditingController();
  final _petCtrl     = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _obscure      = true;
  bool _loading      = false;
  bool _done         = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _petCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  String _stripHtml(String input) => input
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService().forgotPassword(
        email:       _emailCtrl.text.trim(),
        petName:     _petCtrl.text.trim(),
        newPassword: _newPassCtrl.text,
      );
      if (mounted) setState(() { _loading = false; _done = true; });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _stripHtml(e.toString().replaceFirst('Exception: ', '')),
            style: GoogleFonts.spaceGrotesk(color: AppColors.textMain),
          ),
          backgroundColor: AppColors.layer2,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textDim, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _done ? _SuccessView(onBack: () => Navigator.pop(context))
              : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 8),

                Text('Forgot password?',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textMain,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5)),

                const SizedBox(height: 6),

                Text('Enter your email and your pet\'s name to reset.',
                    style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textDim, fontSize: 14)),

                const SizedBox(height: 28),

                /// INFO HINT
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.layer1,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderMuted),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.pets_rounded,
                          size: 14, color: AppColors.textDead),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your pet\'s name was set when you registered. '
                              'It\'s used as your security question.',
                          style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textDim,
                              fontSize: 11,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                AppInput(
                  label: 'Email',
                  placeholder: 'you@example.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 16),

                AppInput(
                  label: "Pet's Name",
                  placeholder: 'e.g. Bruno',
                  controller: _petCtrl,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                AppInput(
                  label: 'New Password',
                  placeholder: '••••••••',
                  obscure: _obscure,
                  controller: _newPassCtrl,
                  validator: Validators.password,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textDead,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),

                const SizedBox(height: 28),

                AppButton(
                  label: _loading ? 'Resetting...' : 'Reset Password',
                  onTap: _loading ? null : _submit,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.check_rounded,
              color: Colors.greenAccent, size: 24),
        ),
        const SizedBox(height: 20),
        Text('Password reset!',
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMain,
                fontSize: 26,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Your password has been updated. You can sign in now.',
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textDim, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),
        AppButton(label: 'Back to Sign In', onTap: onBack),
      ],
    );
  }
}