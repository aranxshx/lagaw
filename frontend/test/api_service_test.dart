import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/location.dart';
import 'package:frontend/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('LocationItem.fromJson', () {
    test('parses full backend schema payload correctly', () {
      final json = {
        'id': '1a3bca09-5532-5de6-8587-2440c4e5',
        'name': 'San Sebastian Cathedral',
        'description': 'Historic cathedral downtown.',
        'category': 'heritage',
        'vibe_tags': ['heritage', 'photography'],
        'address': 'Rizal St, Bacolod City',
        'estimated_cost_min': 0,
        'estimated_cost_max': 0,
        'typical_visit_duration': 45,
        'image_url': 'https://example.com/cathedral.jpg',
      };

      final location = LocationItem.fromJson(json);

      expect(location.id, '1a3bca09-5532-5de6-8587-2440c4e5');
      expect(location.name, 'San Sebastian Cathedral');
      expect(location.category, 'heritage');
      expect(location.costRange, 'Free');
      expect(location.duration, '45 mins');
      expect(location.vibeTags, contains('heritage'));
    });

    test('handles null costs and default fallback image', () {
      final json = {
        'id': 'test-123',
        'name': 'Mystery Spot',
        'category': 'cafe',
      };

      final location = LocationItem.fromJson(json);

      expect(location.name, 'Mystery Spot');
      expect(location.costRange, 'Free');
      expect(location.duration, '60 mins');
      expect(location.imageUrl.isNotEmpty, true);
    });
  });

  group('ApiService', () {
    test('fetchLocations returns list on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, endsWith('/locations'));
        expect(request.url.queryParameters['limit'], '50');

        final payload = {
          'items': [
            {
              'id': 'loc-1',
              'name': 'Manokan Country',
              'category': 'restaurant',
              'description': 'Famous inasal strip.',
              'vibe_tags': ['foodie', 'inasal'],
              'estimated_cost_min': 120,
              'estimated_cost_max': 300,
              'typical_visit_duration': 60,
            }
          ],
          'limit': 50,
          'offset': 0,
        };
        return http.Response(jsonEncode(payload), 200);
      });

      final service = ApiService(client: mockClient);
      final locations = await service.fetchLocations();

      expect(locations.length, 1);
      expect(locations.first.name, 'Manokan Country');
      expect(locations.first.costRange, '₱120 – ₱300');
    });

    test('fetchLocations throws exception on HTTP 503', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"detail":"Database unavailable"}', 503);
      });

      final service = ApiService(client: mockClient);

      expect(
        () => service.fetchLocations(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
