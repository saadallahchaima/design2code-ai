import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Border? border;
  final Color? color;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.surface.withOpacity(0.75),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
