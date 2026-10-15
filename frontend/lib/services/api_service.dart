import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/location.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches locations from the FastAPI backend GET /locations [S1-04]
  Future<List<LocationItem>> fetchLocations({
    int limit = 50,
    int offset = 0,
  }) async {
    final uri = Uri.parse(AppConfig.locationsEndpoint).replace(
      queryParameters: {
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final response = await _client.get(
      uri,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded.containsKey('items')) {
        final items = decoded['items'] as List<dynamic>? ?? [];
        return items
            .map((item) => LocationItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (decoded is List<dynamic>) {
        return decoded
            .map((item) => LocationItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception(
        'Server returned HTTP ${response.statusCode}: ${response.reasonPhrase ?? "Error"}',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
