import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/luxury_app_bar.dart';
import '../../catalog/providers/catalog_providers.dart';
import '../providers/transformation_provider.dart';

class TransformationWorkflowScreen extends ConsumerStatefulWidget {
  const TransformationWorkflowScreen({super.key});

  @override
  ConsumerState<TransformationWorkflowScreen> createState() =>
      _TransformationWorkflowScreenState();
}

class _TransformationWorkflowScreenState
    extends ConsumerState<TransformationWorkflowScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _promptController = TextEditingController();

  final List<String> _roomTypes = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
    'Dining Room',
    'Office',
    'Balcony',
    'Hallway',
  ];

  final List<String> _lightingOptions = [
    'Natural Sunlight & Warm Concealed LED',
    'Golden Hour Ambient Glow',
    'Modern Architectural Recessed Spots',
    'Moody Dramatic Chandelier Lighting',
    'Bright Neutral Daylight',
  ];

  int _currentStep = 0;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked != null) {
        ref
            .read(transformationWorkflowProvider.notifier)
            .setImage(File(picked.path));
        setState(() {
          _currentStep = 1; // Move to room selection
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Room Photograph',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Take a photo of your existing room or choose one from your gallery',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildPickerOption(
                        icon: Icons.camera_alt_rounded,
                        label: 'Take Photo',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildPickerOption(
                        icon: Icons.photo_library_rounded,
                        label: 'From Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryLight, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workflowState = ref.watch(transformationWorkflowProvider);

    // If currently submitting or polling AI
    if (workflowState.isSubmitting) {
      return _buildProcessingScreen(workflowState);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: LuxuryAppBar(
        title: 'Transform Your Home',
        onBack: () => context.pop(),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          _buildProgressTracker(),

          // Step Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentStep == 0) _buildPhotoStep(workflowState),
                  if (_currentStep == 1) _buildRoomStep(workflowState),
                  if (_currentStep == 2) _buildStyleStep(workflowState),
                  if (_currentStep == 3) _buildMaterialsStep(workflowState),
                  if (_currentStep == 4) _buildPromptStep(workflowState),
                ],
              ),
            ),
          ),

          // Bottom Action Navigation Bar
          _buildBottomBar(workflowState),
        ],
      ),
    );
  }

  Widget _buildProgressTracker() {
    final stepLabels = ['Photo', 'Room', 'Style', 'Materials', 'Prompt'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return GestureDetector(
            onTap: () {
              if (index <= _currentStep) {
                setState(() => _currentStep = index);
              }
            },
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? AppColors.primary
                        : isCompleted
                            ? AppColors.primaryDark
                            : AppColors.surfaceElevated,
                    border: Border.all(
                      color: isCurrent ? AppColors.primaryLight : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isCurrent ? Colors.black : AppColors.textMuted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                if (isCurrent)
                  Text(
                    stepLabels[index],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                if (index < 4) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 14,
                    height: 1.5,
                    color: isCompleted ? AppColors.primary : AppColors.border,
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  // STEP 0: Photo Capture
  Widget _buildPhotoStep(TransformationWorkflowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Take or Upload Room Photo',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Take a clear, wide photograph of the room you wish to transform.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        if (state.selectedImage != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.file(
                  state.selectedImage!,
                  height: 380,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Retake / Change',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              height: 340,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 38,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Capture or Upload Room Photo',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap here to choose Camera or Gallery',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // STEP 1: Room Selection
  Widget _buildRoomStep(TransformationWorkflowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Select Room Type',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Which space is shown in your photo?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: _roomTypes.length,
          itemBuilder: (context, index) {
            final room = _roomTypes[index];
            final isSelected = state.roomType == room;
            return GestureDetector(
              onTap: () {
                ref
                    .read(transformationWorkflowProvider.notifier)
                    .setRoomType(room);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primarySubtle : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(
                      _getRoomIcon(room),
                      size: 20,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        room,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getRoomIcon(String room) {
    switch (room.toLowerCase()) {
      case 'living room':
        return Icons.weekend_outlined;
      case 'bedroom':
        return Icons.bed_outlined;
      case 'kitchen':
        return Icons.kitchen_outlined;
      case 'bathroom':
        return Icons.bathtub_outlined;
      case 'dining room':
        return Icons.table_bar_outlined;
      case 'office':
        return Icons.computer_outlined;
      case 'balcony':
        return Icons.deck_outlined;
      default:
        return Icons.meeting_room_outlined;
    }
  }

  // STEP 2: Style Selection
  Widget _buildStyleStep(TransformationWorkflowState state) {
    final stylesAsync = ref.watch(stylesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. Choose Interior Style',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Select the aesthetic atmosphere for the AI architectural redesign.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        stylesAsync.when(
          data: (styles) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: styles.length,
              itemBuilder: (context, index) {
                final style = styles[index];
                final isSelected = state.selectedStyle == style.name;

                return GestureDetector(
                  onTap: () {
                    ref
                        .read(transformationWorkflowProvider.notifier)
                        .setStyle(style.name);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surfaceHighlight : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            style.image,
                            width: 74,
                            height: 74,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: 74,
                              height: 74,
                              color: AppColors.surfaceElevated,
                              child: const Icon(Icons.style, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                style.name,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                style.description,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (e, _) => Text('Error loading styles: $e'),
        ),
      ],
    );
  }

  // STEP 3: Materials
  Widget _buildMaterialsStep(TransformationWorkflowState state) {
    final wallMaterialsAsync = ref.watch(wallMaterialsProvider);
    final floorMaterialsAsync = ref.watch(floorMaterialsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. Materials & Textures',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Customize the wall cladding and flooring for RenoDesign finishing.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        // Wall Materials
        Text(
          'WALL COVERINGS',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        wallMaterialsAsync.when(
          data: (materials) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: materials.map((m) {
                final isSelected = state.selectedWallMaterial == m.name;
                return ChoiceChip(
                  label: Text(m.name),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.black : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  onSelected: (val) {
                    ref
                        .read(transformationWorkflowProvider.notifier)
                        .setWallMaterial(val ? m.name : null);
                  },
                );
              }).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(color: AppColors.primary),
          error: (_, __) => const Text('Materials unavailable'),
        ),

        const SizedBox(height: 24),

        // Floor Materials
        Text(
          'FLOORING SELECTION',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        floorMaterialsAsync.when(
          data: (materials) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: materials.map((m) {
                final isSelected = state.selectedFloorMaterial == m.name;
                return ChoiceChip(
                  label: Text(m.name),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.black : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  onSelected: (val) {
                    ref
                        .read(transformationWorkflowProvider.notifier)
                        .setFloorMaterial(val ? m.name : null);
                  },
                );
              }).toList(),
            );
          },
          loading: () => const LinearProgressIndicator(color: AppColors.primary),
          error: (_, __) => const Text('Materials unavailable'),
        ),

        const SizedBox(height: 24),

        // Lighting Selection
        Text(
          'LIGHTING MOOD',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: state.lighting,
              dropdownColor: AppColors.surfaceElevated,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              items: _lightingOptions
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  ref
                      .read(transformationWorkflowProvider.notifier)
                      .setLighting(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // STEP 4: Custom User Instructions
  Widget _buildPromptStep(TransformationWorkflowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5. Bespoke Requirements',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tell our architectural AI specifically what you envision.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _promptController,
          maxLines: 5,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText:
                'e.g., "Add an Italian marble kitchen island, soft beige fluted walls, natural warm oak chevron floor, and minimalist recessed lighting."',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          onChanged: (val) {
            ref
                .read(transformationWorkflowProvider.notifier)
                .setCustomPrompt(val);
          },
        ),
        const SizedBox(height: 24),

        // Summary Card
        GlassContainer(
          borderRadius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRANSFORMATION SUMMARY',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
              const Divider(color: AppColors.border, height: 20),
              _buildSummaryRow('Room:', state.roomType),
              _buildSummaryRow('Style:', state.selectedStyle ?? 'Not chosen'),
              if (state.selectedWallMaterial != null)
                _buildSummaryRow('Walls:', state.selectedWallMaterial!),
              if (state.selectedFloorMaterial != null)
                _buildSummaryRow('Floor:', state.selectedFloorMaterial!),
              _buildSummaryRow('Lighting:', state.lighting),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
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

  // BOTTOM NAVIGATION BAR
  Widget _buildBottomBar(TransformationWorkflowState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: CustomButton(
                text: 'Back',
                variant: ButtonVariant.secondary,
                onPressed: () {
                  setState(() => _currentStep--);
                },
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: CustomButton(
              text: _currentStep == 4 ? 'Generate Renovation' : 'Next Step',
              icon: _currentStep == 4
                  ? Icons.auto_awesome_rounded
                  : Icons.arrow_forward_rounded,
              onPressed: () async {
                if (_currentStep == 0) {
                  if (state.selectedImage == null) {
                    _showImagePickerOptions();
                    return;
                  }
                  setState(() => _currentStep++);
                } else if (_currentStep < 4) {
                  setState(() => _currentStep++);
                } else {
                  // Submit to real backend AI
                  final result = await ref
                      .read(transformationWorkflowProvider.notifier)
                      .submitTransformation();

                  if (result != null && mounted) {
                    context.push('/transformation-result', extra: result);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // PROCESSING / REAL AI PROGRESS SCREEN
  Widget _buildProcessingScreen(TransformationWorkflowState state) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Glowing Orb
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 36,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 54,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                Text(
                  'Renovating Your Room',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Real-time status text from backend
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    state.statusMessage,
                    key: ValueKey(state.statusMessage),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Progress Indicator
                SizedBox(
                  width: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: state.uploadProgress > 0 ? state.uploadProgress : null,
                      backgroundColor: AppColors.surfaceElevated,
                      color: AppColors.primary,
                      minHeight: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                Text(
                  'Preserving structural geometry, windows and proportions while applying photorealistic materials...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
