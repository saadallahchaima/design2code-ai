import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null,
        );

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LuxuryAppBar(
        title: 'Create Account',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join RenoDesign',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start transforming your interior spaces with cutting-edge AI.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                if (authState.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withOpacity(0.5)),
                    ),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Name Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('FIRST NAME *'),
                          TextFormField(
                            controller: _firstNameController,
                            style: const TextStyle(color: AppColors.textPrimary),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(hintText: 'Jane'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('LAST NAME *'),
                          TextFormField(
                            controller: _lastNameController,
                            style: const TextStyle(color: AppColors.textPrimary),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            decoration: const InputDecoration(hintText: 'Smith'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                _buildLabel('EMAIL ADDRESS *'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary),
                  validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
                  decoration: const InputDecoration(hintText: 'jane.smith@example.com'),
                ),
                const SizedBox(height: 16),

                // Phone
                _buildLabel('PHONE NUMBER (OPTIONAL)'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: '+33 6 00 00 00 00'),
                ),
                const SizedBox(height: 16),

                // Password
                _buildLabel('PASSWORD *'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.textPrimary),
                  validator: (v) => v == null || v.length < 6 ? 'At least 6 characters' : null,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit
                CustomButton(
                  text: 'Create My Account',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
