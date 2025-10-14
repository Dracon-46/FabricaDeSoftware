import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contribuidor_projeto.dart';
import 'base_api_service.dart';

class ContribuidorProjetoService extends BaseApiService {
  ContribuidorProjetoService() : super('/contribuidores-projeto');

  Future<List<ContribuidorProjeto>> getContribuidoresProjeto() async {
    return getAll<ContribuidorProjeto>(ContribuidorProjeto.fromJson);
  }

  Future<ContribuidorProjeto?> getContribuidorProjeto(int contribuidorId, int projetoId) async {
    final Uri uri = buildUri('/contribuidor/$contribuidorId/projeto/$projetoId');
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
      return ContribuidorProjeto.fromJson(json);
    });
  }

  Future<ContribuidorProjeto> createContribuidorProjeto(ContribuidorProjeto contribuidorProjeto) async {
    return create<ContribuidorProjeto>(contribuidorProjeto.toJson(), ContribuidorProjeto.fromJson);
  }

  Future<ContribuidorProjeto> updateContribuidorProjeto(ContribuidorProjeto contribuidorProjeto) async {
    final Uri uri = buildUri('/contribuidor/${contribuidorProjeto.contribuidorId}/projeto/${contribuidorProjeto.projetoId}');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(contribuidorProjeto.toJson()),
    );

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return ContribuidorProjeto.fromJson(json);
    });
  }

  Future<void> deleteContribuidorProjeto(int contribuidorId, int projetoId) async {
    final Uri uri = buildUri('/contribuidor/$contribuidorId/projeto/$projetoId');
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

  Future<List<ContribuidorProjeto>> getByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => ContribuidorProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<ContribuidorProjeto>> getByContribuidor(int contribuidorId) async {
    final Uri uri = buildUri('/contribuidor/$contribuidorId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => ContribuidorProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }
}