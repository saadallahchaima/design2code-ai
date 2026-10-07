import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class BeforeAfterSlider extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final double height;
  final double borderRadius;
  final String beforeLabel;
  final String afterLabel;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.height = 360.0,
    this.borderRadius = 18.0,
    this.beforeLabel = 'BEFORE',
    this.afterLabel = 'AFTER (AI)',
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  // Slider position from 0.0 to 1.0 (0.5 = center)
  double _splitPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            height: widget.height,
            width: totalWidth,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                // 1. Bottom Layer: AFTER IMAGE (Renovated)
                Positioned.fill(
                  child: _buildImage(widget.afterImageUrl),
                ),

                // 2. Top Layer: BEFORE IMAGE (Clipped to split position)
                Positioned.fill(
                  child: ClipRect(
                    clipper: _HorizontalSplitClipper(_splitPosition),
                    child: _buildImage(widget.beforeImageUrl),
                  ),
                ),

                // 3. Floating Badges: BEFORE & AFTER
                Positioned(
                  top: 14,
                  left: 14,
                  child: _buildBadge(widget.beforeLabel, isBefore: true),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: _buildBadge(widget.afterLabel, isBefore: false),
                ),

                // 4. Vertical Divider Line & Draggable Handle
                Positioned(
                  left: (totalWidth * _splitPosition) - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                // 5. Center Thumb Knob with arrows
                Positioned(
                  left: (totalWidth * _splitPosition) - 20,
                  top: (widget.height / 2) - 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.compare_arrows_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),

                // 6. Interactive Gesture Detector over entire container
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _splitPosition = (details.localPosition.dx / totalWidth)
                            .clamp(0.05, 0.95);
                      });
                    },
                    onTapDown: (details) {
                      setState(() {
                        _splitPosition = (details.localPosition.dx / totalWidth)
                            .clamp(0.05, 0.95);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String label, {required bool isBefore}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isBefore
            ? Colors.black.withOpacity(0.65)
            : AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBefore ? Colors.white.withOpacity(0.15) : AppColors.primaryLight,
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
          color: isBefore ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(
        color: AppColors.surfaceElevated,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        color: AppColors.surfaceElevated,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceElevated,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _HorizontalSplitClipper extends CustomClipper<Rect> {
  final double splitFactor;

  _HorizontalSplitClipper(this.splitFactor);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * splitFactor, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalSplitClipper oldClipper) {
    return oldClipper.splitFactor != splitFactor;
  }
}
