import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../catalog/models/service_model.dart';
import '../../../catalog/providers/catalog_providers.dart';

class ServicesHorizontalList extends ConsumerWidget {
  const ServicesHorizontalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return servicesAsync.when(
      data: (services) {
        if (services.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceChipCard(service: service);
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _ServiceChipCard extends StatelessWidget {
  final ServiceModel service;

  const _ServiceChipCard({required this.service});

  IconData _getIconForService(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wall') || lower.contains('paint')) return Icons.format_paint_outlined;
    if (lower.contains('floor')) return Icons.grid_on_rounded;
    if (lower.contains('decorative') || lower.contains('finish')) return Icons.brush_outlined;
    if (lower.contains('consult')) return Icons.lightbulb_outline_rounded;
    return Icons.architecture_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIconForService(service.name),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            service.name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
