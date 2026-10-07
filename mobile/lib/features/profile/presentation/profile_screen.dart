import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LuxuryAppBar(
        title: 'Account & Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                    ),
                    child: Center(
                      child: Text(
                        user != null && user.firstName.isNotEmpty
                            ? user.firstName[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName.isNotEmpty == true
                              ? user!.fullName
                              : 'Guest User',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'Sign in to sync your rooms',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (user?.role == 'ADMIN') ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ADMINISTRATOR',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Menu Options
            _buildMenuItem(
              icon: Icons.auto_awesome_rounded,
              title: 'My AI Transformations',
              subtitle: 'Browse all your generated room designs',
              onTap: () => context.push('/my-transformations'),
            ),
            _buildMenuItem(
              icon: Icons.request_quote_outlined,
              title: 'Request a RenoDesign Quote',
              subtitle: 'Get an architectural estimate for your project',
              onTap: () => context.push('/quote'),
            ),
            _buildMenuItem(
              icon: Icons.info_outline_rounded,
              title: 'About RenoDesign',
              subtitle: 'High-end interior renovation & real-estate finishing',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'RenoDesign',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 RenoDesign Architectural Finishing',
                );
              },
            ),

            const SizedBox(height: 32),

            // Login or Logout Button
            if (authState.isAuthenticated)
              CustomButton(
                text: 'Sign Out',
                variant: ButtonVariant.outline,
                icon: Icons.logout_rounded,
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              )
            else
              CustomButton(
                text: 'Sign In to Your Account',
                icon: Icons.login_rounded,
                onPressed: () => context.push('/login'),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
