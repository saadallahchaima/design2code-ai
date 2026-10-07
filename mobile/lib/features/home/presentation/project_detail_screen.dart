import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/before_after_slider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../../catalog/models/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final hasBeforeAfter = project.beforeImage != null &&
        project.afterImage != null &&
        project.beforeImage!.isNotEmpty &&
        project.afterImage!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LuxuryAppBar(
        title: project.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to Favorites')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share link copied to clipboard')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Before / After Slider or Cover Image
            if (hasBeforeAfter) ...[
              BeforeAfterSlider(
                beforeImageUrl: project.beforeImage!,
                afterImageUrl: project.afterImage!,
                height: 380,
                beforeLabel: 'ORIGINAL ROOM',
                afterLabel: 'RENOVATED BY RD',
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Drag the slider horizontally to compare before & after',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  project.coverImage,
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Metadata Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (project.roomType != null)
                  _buildMetaChip(
                    icon: Icons.meeting_room_outlined,
                    label: project.roomType!,
                  ),
                if (project.style != null)
                  _buildMetaChip(
                    icon: Icons.palette_outlined,
                    label: project.style!,
                  ),
                if (project.location != null)
                  _buildMetaChip(
                    icon: Icons.location_on_outlined,
                    label: project.location!,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Project Title & Description
            Text(
              project.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              project.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 36),

            // CTA: Request Quote for similar project
            CustomButton(
              text: 'Request Quote for Similar Project',
              icon: Icons.request_quote_outlined,
              onPressed: () {
                context.push(
                  '/quote',
                  extra: {
                    'roomType': project.roomType,
                    'message': 'Interested in renovation similar to: ${project.title}',
                  },
                );
              },
            ),
            const SizedBox(height: 14),

            // Secondary: Transform Your Room Now
            CustomButton(
              text: 'Transform My Room With AI',
              variant: ButtonVariant.secondary,
              icon: Icons.auto_awesome_rounded,
              onPressed: () {
                context.push('/transform');
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
