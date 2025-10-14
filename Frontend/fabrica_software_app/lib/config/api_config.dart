class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';

  static Map<String, String> getAuthHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}