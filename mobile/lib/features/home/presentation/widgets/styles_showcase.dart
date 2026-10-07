import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../catalog/models/style_model.dart';
import '../../../catalog/providers/catalog_providers.dart';

class StylesShowcase extends ConsumerWidget {
  final void Function(StyleModel style)? onSelectStyle;

  const StylesShowcase({
    super.key,
    this.onSelectStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stylesAsync = ref.watch(stylesProvider);

    return stylesAsync.when(
      data: (styles) {
        if (styles.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: styles.length,
            itemBuilder: (context, index) {
              final style = styles[index];
              return _StyleCard(
                style: style,
                onTap: () => onSelectStyle?.call(style),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, _) => Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Interior styles could not be loaded',
            style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final StyleModel style;
  final VoidCallback onTap;

  const _StyleCard({
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          color: AppColors.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: style.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceElevated,
                ),
                errorWidget: (context, url, err) => Container(
                  color: AppColors.surfaceElevated,
                  child: const Icon(Icons.style_outlined, color: AppColors.textMuted),
                ),
              ),
            ),

            // Vignette Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Style Details
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    style.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.75),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
