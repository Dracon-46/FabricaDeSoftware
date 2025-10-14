class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';

  // API Endpoints
  static const String login = 'auth/login';
  static const String usuarios = 'usuarios';
  static const String clientes = 'clientes';
  static const String projetos = 'projetos';
  static const String contribuidores = 'contribuidores';
  static const String recursos = 'recursos';
  static const String requisitos = 'requisitos';
  static const String tecnologias = 'tecnologias';
  static const String testes = 'testes';
  static const String treinamentos = 'treinamentos';

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