import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository(this._apiClient, this._tokenStorage);

  Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        await _tokenStorage.saveToken(authResponse.token);
        await _tokenStorage.saveUserData(jsonEncode(authResponse.user.toJson()));
        return authResponse;
      } else {
        final msg = response.data['message'] ?? 'Registration failed';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Network error';
      throw Exception(msg);
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        await _tokenStorage.saveToken(authResponse.token);
        await _tokenStorage.saveUserData(jsonEncode(authResponse.user.toJson()));
        return authResponse;
      } else {
        final msg = response.data['message'] ?? 'Invalid credentials';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Login failed';
      throw Exception(msg);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final hasToken = await _tokenStorage.hasToken();
      if (!hasToken) return null;

      final response = await _apiClient.get(ApiConstants.me);
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data);
        await _tokenStorage.saveUserData(jsonEncode(user.toJson()));
        return user;
      }
      return null;
    } catch (_) {
      // Fallback to locally cached user info if offline
      final cachedJson = await _tokenStorage.getUserData();
      if (cachedJson != null) {
        try {
          return UserModel.fromJson(jsonDecode(cachedJson));
        } catch (_) {}
      }
      return null;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
  }
}
