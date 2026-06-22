import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/search_response.dart';

class FarmacoApiService {
  FarmacoApiService({http.Client? client, this.baseUrl = ApiConfig.baseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<SearchResponse> searchWithAgent(String query) async {
    final uri = Uri.parse(
      '$baseUrl/agente/buscar',
    ).replace(queryParameters: {'q': query});

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error al consultar el backend: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return SearchResponse.fromJson(decoded);
  }

  void dispose() {
    _client.close();
  }
}
