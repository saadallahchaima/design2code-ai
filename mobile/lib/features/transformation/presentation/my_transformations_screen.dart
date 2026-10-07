import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../providers/transformation_provider.dart';

class MyTransformationsScreen extends ConsumerWidget {
  const MyTransformationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(myTransformationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const LuxuryAppBar(
        title: 'My Saved Visions',
        showBackButton: false,
      ),
      body: listAsync.when(
        data: (transformations) {
          if (transformations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Transformations Yet',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo of your living room, kitchen or bedroom and watch real AI reimagine it.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Start First Transformation',
                      icon: Icons.camera_alt_outlined,
                      onPressed: () => context.push('/transform'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              ref.invalidate(myTransformationsProvider);
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(16),
              itemCount: transformations.length,
              itemBuilder: (context, index) {
                final item = transformations[index];
                final displayImg = item.generatedImageUrl ?? item.originalImageUrl;

                return GestureDetector(
                  onTap: () {
                    context.push('/transformation-result', extra: item);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          displayImg,
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 190,
                            color: AppColors.surfaceElevated,
                            child: const Icon(Icons.image, color: AppColors.textMuted),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.style} ${item.roomType}',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Status: ${item.status}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: item.isCompleted
                                            ? AppColors.primaryLight
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text('Failed to load: $e'),
        ),
      ),
    );
  }
}
