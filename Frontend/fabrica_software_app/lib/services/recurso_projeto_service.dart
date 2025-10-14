import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recurso_projeto.dart';
import 'base_api_service.dart';

class RecursoProjetoService extends BaseApiService {
  RecursoProjetoService() : super('/recursos-projeto');

  Future<List<RecursoProjeto>> getRecursosProjeto() async {
    return getAll<RecursoProjeto>(RecursoProjeto.fromJson);
  }

  Future<List<RecursoProjeto>> getByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => RecursoProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<RecursoProjeto>> getByRecurso(int recursoId) async {
    final Uri uri = buildUri('/recurso/$recursoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => RecursoProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<RecursoProjeto?> getRecursoProjeto(int recursoId, int projetoId) async {
    final Uri uri = buildUri('/recurso/$recursoId/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 404) {
      return null;
    }

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return RecursoProjeto.fromJson(json);
    });
  }

  Future<RecursoProjeto> createRecursoProjeto(RecursoProjeto recursoProjeto) async {
    return create<RecursoProjeto>(recursoProjeto.toJson(), RecursoProjeto.fromJson);
  }

  Future<RecursoProjeto> updateRecursoProjeto(RecursoProjeto recursoProjeto) async {
    final Uri uri = buildUri('/recurso/${recursoProjeto.recursoId}/projeto/${recursoProjeto.projetoId}');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(recursoProjeto.toJson()),
    );

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return RecursoProjeto.fromJson(json);
    });
  }

  Future<void> deleteRecursoProjeto(int recursoId, int projetoId) async {
    final Uri uri = buildUri('/recurso/$recursoId/projeto/$projetoId');
    final response = await http.delete(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final message = body?['message'] ?? 'Erro ao excluir';
      throw ApiException(message, response.statusCode);
    }
  }
}