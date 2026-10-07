import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/before_after_slider.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../models/transformation_model.dart';
import '../providers/transformation_provider.dart';

class TransformationResultScreen extends ConsumerStatefulWidget {
  final TransformationModel transformation;

  const TransformationResultScreen({
    super.key,
    required this.transformation,
  });

  @override
  ConsumerState<TransformationResultScreen> createState() =>
      _TransformationResultScreenState();
}

class _TransformationResultScreenState
    extends ConsumerState<TransformationResultScreen> {
  late TransformationModel _currentTransformation;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    _currentTransformation = widget.transformation;
  }

  Future<void> _regenerate() async {
    setState(() => _isRegenerating = true);
    try {
      final updated = await ref
          .read(transformationRepositoryProvider)
          .regenerateTransformation(_currentTransformation.id);
      if (!mounted) return;
      setState(() {
        _currentTransformation = updated;
        _isRegenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Renovation regenerated with new nuances!')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRegenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to regenerate: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasGenerated = _currentTransformation.generatedImageUrl != null &&
        _currentTransformation.generatedImageUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LuxuryAppBar(
        title: 'Transformation Result',
        onBack: () => context.go('/home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transformation link copied')),
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
            // Before / After Slider
            if (hasGenerated) ...[
              BeforeAfterSlider(
                beforeImageUrl: _currentTransformation.originalImageUrl,
                afterImageUrl: _currentTransformation.generatedImageUrl!,
                height: 400,
                beforeLabel: 'YOUR ORIGINAL ROOM',
                afterLabel: 'RENODESIGN AI VISION',
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Drag the handle left/right to inspect renovated finishes',
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
                  _currentTransformation.originalImageUrl,
                  height: 340,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Status: ${_currentTransformation.status}',
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Transformation Architectural Details Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'APPLIED SPECIFICATIONS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentTransformation.status,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 20),
                  _buildDetailRow(
                    Icons.meeting_room_outlined,
                    'Room Type',
                    _currentTransformation.roomType,
                  ),
                  _buildDetailRow(
                    Icons.palette_outlined,
                    'Design Style',
                    _currentTransformation.style,
                  ),
                  if (_currentTransformation.wallMaterial != null)
                    _buildDetailRow(
                      Icons.format_paint_outlined,
                      'Wall Covering',
                      _currentTransformation.wallMaterial!,
                    ),
                  if (_currentTransformation.floorMaterial != null)
                    _buildDetailRow(
                      Icons.grid_on_outlined,
                      'Flooring',
                      _currentTransformation.floorMaterial!,
                    ),
                  if (_currentTransformation.lighting != null)
                    _buildDetailRow(
                      Icons.lightbulb_outline_rounded,
                      'Lighting Mood',
                      _currentTransformation.lighting!,
                    ),
                  if (_currentTransformation.customPrompt != null &&
                      _currentTransformation.customPrompt!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Custom Request:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${_currentTransformation.customPrompt}"',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Main CTA: Request Real Quote
            CustomButton(
              text: 'Request Real Quote For This Renovation',
              icon: Icons.assignment_outlined,
              height: 54,
              onPressed: () {
                context.push(
                  '/quote',
                  extra: {
                    'transformationId': _currentTransformation.id,
                    'roomType': _currentTransformation.roomType,
                    'message':
                        'Quote requested for ${_currentTransformation.style} style renovation.',
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // Secondary Buttons: Regenerate & Try Another Style
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Regenerate',
                    icon: Icons.refresh_rounded,
                    variant: ButtonVariant.secondary,
                    isLoading: _isRegenerating,
                    onPressed: _regenerate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'New Style',
                    icon: Icons.auto_fix_high_rounded,
                    variant: ButtonVariant.secondary,
                    onPressed: () {
                      context.push('/transform');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
