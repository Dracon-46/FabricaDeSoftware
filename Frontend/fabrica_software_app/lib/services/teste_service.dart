import 'package:http/http.dart' as http;
import '../models/teste.dart';
import 'base_api_service.dart';

class TesteService extends BaseApiService {
  TesteService() : super('/testes');

  Future<List<Teste>> getTestes() async {
    return getAll<Teste>(Teste.fromJson);
  }

  Future<Teste> getTeste(int id) async {
    return getById<Teste>(id, Teste.fromJson);
  }

  Future<List<Teste>> getTestesByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => Teste.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<Teste> createTeste(Teste teste) async {
    return create<Teste>(teste.toJson(), Teste.fromJson);
  }

  Future<Teste> updateTeste(Teste teste) async {
    return update<Teste>(teste.id ?? 0, teste.toJson(), Teste.fromJson);
  }

  Future<void> deleteTeste(int id) async {
    return delete(id);
  }
}