import 'package:http/http.dart' as http;
import '../models/log.dart';
import 'base_api_service.dart';

class LogService extends BaseApiService {
  LogService() : super('/logs');

  Future<List<Log>> getLogs() async {
    return getAll<Log>(Log.fromJson);
  }

  Future<Log> getLog(int id) async {
    return getById<Log>(id, Log.fromJson);
  }

  Future<List<Log>> getLogsByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => Log.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<List<Log>> getLogsByUsuario(int usuarioId) async {
    final Uri uri = buildUri('/usuario/$usuarioId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => Log.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<Log> createLog(Log log) async {
    return create<Log>(log.toJson(), Log.fromJson);
  }

  Future<void> deleteLog(int id) async {
    return delete(id);
  }
}