import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/transformation_model.dart';

class TransformationRepository {
  final ApiClient _apiClient;

  TransformationRepository(this._apiClient);

  Future<TransformationModel> createTransformation({
    required File imageFile,
    required String roomType,
    required String style,
    String? wallMaterial,
    String? floorMaterial,
    String? lighting,
    String? customPrompt,
    void Function(int sent, int total)? onProgress,
  }) async {
    final fileName = imageFile.path.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();
    final mimeType = (extension == 'png')
        ? MediaType('image', 'png')
        : (extension == 'webp')
            ? MediaType('image', 'webp')
            : MediaType('image', 'jpeg');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: mimeType,
      ),
      'roomType': roomType,
      'style': style,
      if (wallMaterial != null && wallMaterial.isNotEmpty)
        'wallMaterial': wallMaterial,
      if (floorMaterial != null && floorMaterial.isNotEmpty)
        'floorMaterial': floorMaterial,
      if (lighting != null && lighting.isNotEmpty) 'lighting': lighting,
      if (customPrompt != null && customPrompt.isNotEmpty)
        'customPrompt': customPrompt,
    });

    final response = await _apiClient.uploadMultipart(
      ApiConstants.transformations,
      formData: formData,
      onSendProgress: onProgress,
    );

    // Backend returns 202 Accepted for async AI processing jobs
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final data = response.data['data'] as Map<String, dynamic>;
      return TransformationModel.fromJson(data);
    }
    throw Exception(response.data['message'] ?? 'Transformation request failed');
  }

  Future<TransformationModel> getTransformation(int id) async {
    final response = await _apiClient.get('${ApiConstants.transformations}/$id');
    if (response.statusCode == 200) {
      final data = response.data['data'] as Map<String, dynamic>;
      return TransformationModel.fromJson(data);
    }
    throw Exception('Failed to fetch transformation status');
  }

  Future<List<TransformationModel>> getMyTransformations() async {
    final response = await _apiClient.get(ApiConstants.transformations);
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((item) => TransformationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load transformations');
  }

  Future<void> deleteTransformation(int id) async {
    final response = await _apiClient.delete('${ApiConstants.transformations}/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transformation');
    }
  }

  Future<TransformationModel> regenerateTransformation(int id) async {
    final response = await _apiClient.post(
      '${ApiConstants.transformations}/$id/regenerate',
    );
    if (response.statusCode == 200) {
      final data = response.data['data'] as Map<String, dynamic>;
      return TransformationModel.fromJson(data);
    }
    throw Exception('Failed to regenerate transformation');
  }
}
