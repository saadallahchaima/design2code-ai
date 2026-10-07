import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/catalog/models/project_model.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/project_detail_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/quote/presentation/quote_request_screen.dart';
import '../../features/transformation/models/transformation_model.dart';
import '../../features/transformation/presentation/my_transformations_screen.dart';
import '../../features/transformation/presentation/transformation_result_screen.dart';
import '../../features/transformation/presentation/transformation_workflow_screen.dart';
import '../constants/app_colors.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // Shell Route for Bottom Navigation Bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/my-transformations',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyTransformationsScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // Full-Screen Dedicated Flow Routes
    GoRoute(
      path: '/transform',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransformationWorkflowScreen(),
    ),
    GoRoute(
      path: '/transformation-result',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final transformation = state.extra as TransformationModel;
        return TransformationResultScreen(transformation: transformation);
      },
    ),
    GoRoute(
      path: '/project/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final project = state.extra as ProjectModel;
        return ProjectDetailScreen(project: project);
      },
    ),
    GoRoute(
      path: '/quote',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return QuoteRequestScreen(initialData: data);
      },
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/my-transformations')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/my-transformations');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      // Floating Luxury Center AI Transform Action Button
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.transparent,
        onPressed: () => context.push('/transform'),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.goldGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int idx) => _onItemTapped(idx, context),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library_outlined),
              activeIcon: Icon(Icons.photo_library_rounded),
              label: 'My Visions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
