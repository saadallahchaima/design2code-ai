import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client_provider.dart';
import '../data/catalog_repository.dart';
import '../models/material_model.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';
import '../models/style_model.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

final stylesProvider = FutureProvider<List<StyleModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return await repo.getStyles();
});

final wallMaterialsProvider = FutureProvider<List<MaterialModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return await repo.getMaterials(category: 'wall');
});

final floorMaterialsProvider = FutureProvider<List<MaterialModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return await repo.getMaterials(category: 'floor');
});

final projectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return await repo.getProjects();
});

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return await repo.getServices();
});
