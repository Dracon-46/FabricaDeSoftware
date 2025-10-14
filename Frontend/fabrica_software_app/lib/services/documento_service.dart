import 'package:http/http.dart' as http;
import '../models/documento.dart';
import 'base_api_service.dart';

class DocumentoService extends BaseApiService {
  DocumentoService() : super('/documentos');

  Future<List<Documento>> getDocumentos() async {
    return getAll<Documento>(Documento.fromJson);
  }

  Future<Documento> getDocumento(int id) async {
    return getById<Documento>(id, Documento.fromJson);
  }

  Future<List<Documento>> getDocumentosByProjeto(int projetoId) async {
    final Uri uri = buildUri('/projeto/$projetoId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    return handleResponse(response, (json) {
      if (json is! List) throw ApiException('Resposta inválida do servidor');
      return json.map((item) => Documento.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  Future<Documento> createDocumento(Documento documento) async {
    return create<Documento>(documento.toJson(), Documento.fromJson);
  }

  Future<Documento> updateDocumento(Documento documento) async {
    return update<Documento>(documento.id ?? 0, documento.toJson(), Documento.fromJson);
  }

  Future<void> deleteDocumento(int id) async {
    return delete(id);
  }
}