import 'dart:convert';

import 'package:login/data/sources/error_state.dart';
import 'package:login/data/sources/rest_service.dart';
import 'package:login/domain/model/user_model.dart';
import 'package:login/util/either.dart';
import 'package:login/util/shared_preferences.dart';
class AuthRepository {
  final RestService restService;

  AuthRepository({required this.restService});

  final String _baseUrl = 'http://10.114.181.205:8082';

  Future<ErrorState> login({required Map<String, String> userInfo}) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');
    final Map<String, String> headers = {'Content-Type' : 'application/json'};
    final String body = jsonEncode(userInfo);

    final response = await restService.post(url, headers, body);

    if (response == null) return ErrorState.error;

    if (response['status_cd'] == 200) {
      final String token = response['body']['access_token'];
      prefs.prefs.setString('token', token);
      return ErrorState.success;
    }

    if (response['status_cd'] == 401) return ErrorState.userNotFound;
    if (response['status_cd'] == 404) return ErrorState.notFound;


    return ErrorState.error;
  }

  Future<ErrorState> register({required Map<String, String> userInfo}) async {
    final Uri url = Uri.parse('$_baseUrl/auth/register');
    final Map<String, String> headers = {'Content-Type' : 'application/json'};
    final String body = jsonEncode(userInfo);

    final response = await restService.post(url, headers, body);

    if (response == null) return ErrorState.error;

    if (response['status_cd'] == 201) return ErrorState.success;

    if (response['status_cd'] == 400) return ErrorState.alreadyUser;
    if (response['status_cd'] == 404) return ErrorState.notFound;

    return ErrorState.error;
  }

  Future<ErrorState> update({required Map<String, dynamic> userInfo}) async {
    final String token = prefs.prefs.getString('token') ?? '';
    final Uri url = Uri.parse('$_baseUrl/user/update');
    final Map<String, String> headers = {
      'Authorization' : 'Bearer $token',
      'Content-Type' : 'application/json',
    };
    final String body = jsonEncode(userInfo);

    final response = await restService.put(url, headers, body);

    if (response == null) return ErrorState.error;

    if (response['status_cd'] == 200) return ErrorState.success;

    return ErrorState.error;
  }

  Future<Either<ErrorState, UserModel>> getUserProfile() async {
    final String token = prefs.prefs.getString('token') ?? '';
    final Uri url = Uri.parse('$_baseUrl/user');
    final Map<String, String> headers = {
      'Authorization' : 'Bearer $token',
      'Content-Type' : 'application/json',
    };

    final response = await restService.get(url, headers);

    if (response == null) return Left(ErrorState.error);

    if (response['status_cd'] == 200) return Right(UserModel.fromJson(response['body']));

    if (response['status_cd'] == 401) return Left(ErrorState.expiredToken);

    return Left(ErrorState.error);
  }
}