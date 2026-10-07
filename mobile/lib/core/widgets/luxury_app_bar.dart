import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'glass_container.dart';

class LuxuryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const LuxuryAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      color: Colors.transparent,
      child: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: const GlassContainer(
                borderRadius: 12,
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(
                Icons.architecture_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
