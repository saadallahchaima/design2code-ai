import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/quote_model.dart';

class QuoteRepository {
  final ApiClient _apiClient;

  QuoteRepository(this._apiClient);

  Future<QuoteModel> submitQuote({
    int? transformationId,
    required String fullName,
    required String phone,
    required String email,
    String? city,
    String? roomType,
    double? surfaceArea,
    String? message,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.quotes,
      data: {
        if (transformationId != null) 'transformationId': transformationId,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        if (city != null && city.isNotEmpty) 'city': city,
        if (roomType != null && roomType.isNotEmpty) 'roomType': roomType,
        if (surfaceArea != null) 'surfaceArea': surfaceArea,
        if (message != null && message.isNotEmpty) 'message': message,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] as Map<String, dynamic>;
      return QuoteModel.fromJson(data);
    }
    throw Exception(response.data['message'] ?? 'Failed to submit quote request');
  }

  Future<List<QuoteModel>> getMyQuotes() async {
    final response = await _apiClient.get(ApiConstants.quotes);
    if (response.statusCode == 200) {
      final list = response.data['data'] as List<dynamic>;
      return list.map((item) => QuoteModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load quote requests');
  }
}
