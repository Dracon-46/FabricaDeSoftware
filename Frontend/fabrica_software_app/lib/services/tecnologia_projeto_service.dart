import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tecnologia_projeto.dart';
import 'base_api_service.dart';

class TecnologiaProjetoService extends BaseApiService {
  TecnologiaProjetoService() : super('/tecnologias-projeto');

  Future<List<TecnologiaProjeto>> getTecnologiasProjeto() async {
    return getAll<TecnologiaProjeto>(TecnologiaProjeto.fromJson);
  }

  Future<List<TecnologiaProjeto>> getByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => TecnologiaProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<TecnologiaProjeto>> getByTecnologia(int tecnologiaId) async {
    final Uri uri = buildUri('/tecnologia/$tecnologiaId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => TecnologiaProjeto.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<TecnologiaProjeto?> getTecnologiaProjeto(int tecnologiaId, int projetoId) async {
    final Uri uri = buildUri('/tecnologia/$tecnologiaId/projeto/$projetoId');
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
      return TecnologiaProjeto.fromJson(json);
    });
  }

  Future<TecnologiaProjeto> createTecnologiaProjeto(TecnologiaProjeto tecnologiaProjeto) async {
    return create<TecnologiaProjeto>(tecnologiaProjeto.toJson(), TecnologiaProjeto.fromJson);
  }

  Future<TecnologiaProjeto> updateTecnologiaProjeto(TecnologiaProjeto tecnologiaProjeto) async {
    final Uri uri = buildUri('/tecnologia/${tecnologiaProjeto.tecnologiaId}/projeto/${tecnologiaProjeto.projetoId}');
    final response = await http.put(
      uri,
      headers: await getHeaders(),
      body: jsonEncode(tecnologiaProjeto.toJson()),
    );

    return handleResponse(response, (json) {
      if (json is! Map<String, dynamic>) {
        throw ApiException('Resposta inválida do servidor');
      }
      return TecnologiaProjeto.fromJson(json);
    });
  }

  Future<void> deleteTecnologiaProjeto(int tecnologiaId, int projetoId) async {
    final Uri uri = buildUri('/tecnologia/$tecnologiaId/projeto/$projetoId');
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