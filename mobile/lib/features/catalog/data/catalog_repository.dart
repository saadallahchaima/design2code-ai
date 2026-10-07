import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/material_model.dart';
import '../models/project_model.dart';
import '../models/service_model.dart';
import '../models/style_model.dart';

class CatalogRepository {
  final ApiClient _apiClient;

  CatalogRepository(this._apiClient);

  Future<List<StyleModel>> getStyles() async {
    final response = await _apiClient.get(ApiConstants.styles);
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => StyleModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load interior styles');
  }

  Future<List<MaterialModel>> getMaterials({String? category}) async {
    final response = await _apiClient.get(
      ApiConstants.materials,
      queryParameters: category != null ? {'category': category} : null,
    );
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => MaterialModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load materials');
  }

  Future<List<ProjectModel>> getProjects({String? roomType, String? style}) async {
    final Map<String, dynamic> query = {};
    if (roomType != null) query['roomType'] = roomType;
    if (style != null) query['style'] = style;

    final response = await _apiClient.get(
      ApiConstants.projects,
      queryParameters: query.isNotEmpty ? query : null,
    );
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => ProjectModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load renovation projects');
  }

  Future<ProjectModel> getProjectById(int id) async {
    final response = await _apiClient.get('${ApiConstants.projects}/$id');
    if (response.statusCode == 200) {
      return ProjectModel.fromJson(response.data['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to load project details');
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await _apiClient.get(ApiConstants.services);
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => ServiceModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load services');
  }
}
