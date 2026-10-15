class AppConfig {
  /// Configurable via: flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static String get locationsEndpoint => '$apiBaseUrl/locations';
}
