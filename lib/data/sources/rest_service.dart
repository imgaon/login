import 'dart:convert';

import 'package:http/http.dart';

class RestService {
  final Client _client = Client();

  Future<Map<String, dynamic>?> get(Uri url, Map<String, String> headers) async {
    try {
      final response = await _client.get(url, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(Uri url, Map<String, String> headers, String body) async {
    try {
      final response = await _client.post(url, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> put(Uri url, Map<String, String> headers, String body) async {
    try {
      final response = await _client.put(url, headers: headers, body: body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }
}