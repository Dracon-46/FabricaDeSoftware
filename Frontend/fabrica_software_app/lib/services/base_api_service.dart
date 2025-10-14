import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class BaseApiService {
  final String endpoint;
  
  BaseApiService(this.endpoint);

  @protected
  Uri buildUri([String? path]) {
    final url = '${ApiConfig.baseUrl}$endpoint${path ?? ''}';
    return Uri.parse(url);
  }

  @protected
  Future<Map<String, String>> getHeaders() async {
    final token = await AuthService.instance.token;
    final headers = ApiConfig.getAuthHeaders(token);
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    return headers;
  }

  @protected
  Future<T> handleResponse<T>(http.Response response, T Function(dynamic json) parser) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final json = jsonDecode(response.body);
        return parser(json);
      } catch (e) {
        throw ApiException('Erro ao processar resposta do servidor: ${e.toString()}');
      }
    } else if (response.statusCode == 401) {
      throw ApiException('Não autorizado. Faça login novamente.', 401);
    } else if (response.statusCode == 403) {
      throw ApiException('Sem permissão para acessar este recurso.', 403);
    } else if (response.statusCode == 404) {
      throw ApiException('Recurso não encontrado.', 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Erro interno do servidor.', response.statusCode);
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final message = body?['message'] ?? 'Erro na requisição';
      throw ApiException(message, response.statusCode);
    }
  }

  // Métodos HTTP diretos para testes
  Future<http.Response> get(String path) async {
    return _executeWithRetry(() async => await http.get(
      buildUri(path),
      headers: await getHeaders(),
    ));
  }

  Future<http.Response> post(String path, dynamic data) async {
    return _executeWithRetry(() async => await http.post(
      buildUri(path),
      headers: await getHeaders(),
      body: jsonEncode(data),
    ));
  }

  Future<http.Response> put(String path, dynamic data) async {
    return _executeWithRetry(() async => await http.put(
      buildUri(path),
      headers: await getHeaders(),
      body: jsonEncode(data),
    ));
  }

  Future<http.Response> deleteByPath(String path) async {
    return _executeWithRetry(() async => await http.delete(
      buildUri(path),
      headers: await getHeaders(),
    ));
  }

  static const _maxRetries = 2;

  Future<http.Response> _executeWithRetry(Future<http.Response> Function() request) async {
    int retries = 0;
    while (true) {
      try {
        final response = await request();
        if (response.statusCode == 401 && retries < _maxRetries) {
          // Token pode ter expirado, tentar refresh
          final refreshed = await AuthService.instance.refreshToken();
          if (refreshed) {
            retries++;
            continue;
          }
        }
        return response;
      } catch (e) {
        if (retries >= _maxRetries) {
          rethrow;
        }
        retries++;
      }
    }
  }

  Future<List<T>> getAll<T>(T Function(Map<String, dynamic> json) fromJson, {String? path}) async {
    final response = await _executeWithRetry(() async => await http.get(
      buildUri(path),
      headers: await getHeaders(),
    ));

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<T> getById<T>(int id, T Function(Map<String, dynamic> json) fromJson) async {
    final response = await _executeWithRetry(() async => await http.get(
      buildUri('/$id'),
      headers: await getHeaders(),
    ));

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return fromJson(json);
    });
  }

  Future<T> create<T>(Map<String, dynamic> data, T Function(Map<String, dynamic> json) fromJson) async {
    final response = await _executeWithRetry(() async => await http.post(
      buildUri(),
      headers: await getHeaders(),
      body: jsonEncode(data),
    ));

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return fromJson(json);
    });
  }

  Future<T> update<T>(int id, Map<String, dynamic> data, T Function(Map<String, dynamic> json) fromJson) async {
    final response = await _executeWithRetry(() async => await http.put(
      buildUri('/$id'),
      headers: await getHeaders(),
      body: jsonEncode(data),
    ));

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return fromJson(json);
    });
  }

  Future<void> delete(int id) async {
    final response = await _executeWithRetry(() async => await http.delete(
      buildUri('/$id'),
      headers: await getHeaders(),
    ));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final message = body?['message'] ?? 'Erro ao excluir';
      throw ApiException(message, response.statusCode);
    }
  }
}