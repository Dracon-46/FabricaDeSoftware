import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/requisito_projeto.dart';
import 'base_api_service.dart';

class RequisitoProjetoService extends BaseApiService {
  RequisitoProjetoService() : super('/requisitos-projeto');

  Future<List<RequisitoProjeto>> getRequisitosProjeto() async {
    return getAll<RequisitoProjeto>(RequisitoProjeto.fromJson);
  }

  Future<List<RequisitoProjeto>> getByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => RequisitoProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<RequisitoProjeto>> getByRequisito(int requisitoId) async {
    final Uri uri = buildUri('/requisito/$requisitoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => RequisitoProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<RequisitoProjeto?> getRequisitoProjeto(int requisitoId, int projetoId) async {
    final Uri uri = buildUri('/requisito/$requisitoId/projeto/$projetoId');
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
      return RequisitoProjeto.fromJson(json);
    });
  }

  Future<RequisitoProjeto> createRequisitoProjeto(RequisitoProjeto requisitoProjeto) async {
    return create<RequisitoProjeto>(requisitoProjeto.toJson(), RequisitoProjeto.fromJson);
  }

  Future<RequisitoProjeto> updateRequisitoProjeto(RequisitoProjeto requisitoProjeto) async {
    final Uri uri = buildUri('/requisito/${requisitoProjeto.requisitoId}/projeto/${requisitoProjeto.projetoId}');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(requisitoProjeto.toJson()),
    );

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return RequisitoProjeto.fromJson(json);
    });
  }

  Future<void> deleteRequisitoProjeto(int requisitoId, int projetoId) async {
    final Uri uri = buildUri('/requisito/$requisitoId/projeto/$projetoId');
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