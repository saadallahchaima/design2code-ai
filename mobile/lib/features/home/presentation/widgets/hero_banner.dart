import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback onStartTransformation;

  const HeroBanner({
    super.key,
    required this.onStartTransformation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.heroOverlayGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Gold Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primaryLight,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'AI INTERIOR TRANSFORMATION',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Main Display Headline
            Text(
              'Transform Your\nLiving Space.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.15,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Capture your room and watch real architectural AI redesign it in seconds.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.85),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Start AI Transformation Button
            CustomButton(
              text: 'Start AI Transformation',
              icon: Icons.camera_alt_outlined,
              height: 52,
              onPressed: onStartTransformation,
            ),
          ],
        ),
      ),
    );
  }
}
