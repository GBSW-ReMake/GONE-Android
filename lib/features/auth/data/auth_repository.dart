import 'package:dio/dio.dart';
import 'package:gone/core/error/api_error_code.dart';

import '../../../core/network/auth_tokens.dart';
import '../../../core/network/token_storage.dart';

class AuthRepository {
  AuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<ApiErrorCode?> signup(String id, String password, String phoneNumber, String ticket) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/signup',
        data: {
          "loginId": id,
          "password": password,
          "phoneNumber": phoneNumber,
          "ticket": ticket
        },
      );

      final jsonBody = response.data;
      final errorCode = ApiErrorCode.from(jsonBody['code']);
      print(jsonBody);
      if (errorCode == null) {
        await _tokenStorage.save(AuthTokens.fromJson(jsonBody['data']));
      }

      return errorCode;
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return ApiErrorCode.from(data['code']);
    }
  }

  Future<ApiErrorCode?> login(String id, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: {"identifier": id, "password": password},
      );

      final jsonBody = response.data;
      final errorCode = ApiErrorCode.from(jsonBody['code']);
      print(jsonBody);
      if (errorCode == null) {
        await _tokenStorage.save(AuthTokens.fromJson(jsonBody['data']));
      }

      return errorCode;
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return ApiErrorCode.from(data['code']);
    }
  }

  Future<ApiErrorCode?> loginIdCheck(String id) async {
    try {
      final response = await _dio.get(
        '/api/v1/auth/login-id/check',
        queryParameters: {"loginId": id},
      );

      final jsonBody = response.data;
      print(jsonBody);

      return ApiErrorCode.from(jsonBody['code']);
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return ApiErrorCode.from(data['code']);
    }
  }

  /// 회원가입시에 사용되지 않음
  Future<void> nameCheck() async {}

  Future<Map> sendPhoneCode(String phoneNumber) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/phone/send-code',
        data: {"phoneNumber": phoneNumber},
      );

      final jsonBody = response.data;
      print(jsonBody);
      return jsonBody;
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return data ?? {};
    }
  }

  Future<Map> verifyPhoneCode(String phoneNumber, String code) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/phone/verify-code',
        data: {"phoneNumber": phoneNumber, "code": code},
      );

      final jsonBody = response.data;
      print(jsonBody);
      return jsonBody;
    } catch (e) {
      final error = e as DioException;
      final data = error.response?.data;
      print(data);
      return data ?? {};
    }
  }
}
