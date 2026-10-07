import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage tokenStorage;

  ApiClient({required this.tokenStorage, void Function()? onUnauthorized}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(tokenStorage, onUnauthorized: onUnauthorized),
    );

    // Logging interceptor for debugging in dev
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ),
    );
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart upload (for images)
  Future<Response> uploadMultipart(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return await dio.post(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
