import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

enum ButtonVariant { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonVariant variant;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == ButtonVariant.outline) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _buildContent(AppColors.primary),
        ),
      );
    }

    if (variant == ButtonVariant.secondary) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceElevated,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          child: _buildContent(AppColors.textPrimary),
        ),
      );
    }

    // Default: Luxury Gold Primary Button
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed == null || isLoading
            ? null
            : AppColors.goldGradient,
        color: onPressed == null || isLoading
            ? AppColors.surfaceElevated
            : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: onPressed == null || isLoading
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: _buildContent(Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: textColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 19, color: textColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
