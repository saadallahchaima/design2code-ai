import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../catalog/providers/catalog_providers.dart';
import 'widgets/hero_banner.dart';
import 'widgets/project_card.dart';
import 'widgets/services_horizontal_list.dart';
import 'widgets/styles_showcase.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Luxury Top App Bar
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            pinned: false,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'RD',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RenoDesign',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'ARCHITECTURAL INTERIORS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Main Hero Banner
          SliverToBoxAdapter(
            child: HeroBanner(
              onStartTransformation: () {
                context.push('/transform');
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Section 1: Interior Styles
          SliverToBoxAdapter(
            child: SectionHeader(
              subtitle: 'AESTHETIC DIRECTIONS',
              title: 'Curated Design Styles',
              actionText: 'Explore',
              onActionTap: () => context.push('/transform'),
            ),
          ),
          SliverToBoxAdapter(
            child: StylesShowcase(
              onSelectStyle: (style) {
                context.push('/transform');
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 26)),

          // Section 2: RenoDesign Services
          const SliverToBoxAdapter(
            child: SectionHeader(
              subtitle: 'EXPERTISE',
              title: 'Our Renovation Services',
            ),
          ),
          const SliverToBoxAdapter(
            child: ServicesHorizontalList(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 26)),

          // Section 3: Completed Projects
          const SliverToBoxAdapter(
            child: SectionHeader(
              subtitle: 'BEFORE & AFTER PORTFOLIO',
              title: 'Featured Transformations',
            ),
          ),

          // Project List
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No projects available yet'),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = projects[index];
                    return ProjectCard(
                      project: project,
                      onTap: () {
                        context.push('/project/${project.id}', extra: project);
                      },
                    );
                  },
                  childCount: projects.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
            error: (err, _) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Failed to load projects: $err',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
