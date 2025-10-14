import '../models/tecnologia_projeto.dart';
import 'base_api_service.dart';

class TecnologiasProjetoService extends BaseApiService {
  static final TecnologiasProjetoService instance = TecnologiasProjetoService._();
  
  TecnologiasProjetoService._() : super('/tecnologias-projeto');

  // Operações básicas CRUD
  Future<List<TecnologiaProjeto>> listarTecnologiasProjeto() async {
    return super.getAll((json) => TecnologiaProjeto.fromJson(json));
  }

  Future<TecnologiaProjeto> buscarTecnologiaProjeto(int id) async {
    return super.getById(id, (json) => TecnologiaProjeto.fromJson(json));
  }

  Future<TecnologiaProjeto> adicionarTecnologiaProjeto(Map<String, dynamic> data) async {
    return super.create(data, (json) => TecnologiaProjeto.fromJson(json));
  }

  Future<TecnologiaProjeto> atualizarTecnologiaProjeto(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => TecnologiaProjeto.fromJson(json));
  }

  Future<void> removerTecnologiaProjeto(int id) async {
    return super.delete(id);
  }

  // Operações específicas de relacionamento
  Future<List<TecnologiaProjeto>> listarPorProjeto(int projetoId) async {
    return super.getAll(
      (json) => TecnologiaProjeto.fromJson(json),
      path: '/projeto/$projetoId'
    );
  }

  Future<List<TecnologiaProjeto>> listarPorTecnologia(int tecnologiaId) async {
    return super.getAll(
      (json) => TecnologiaProjeto.fromJson(json),
      path: '/tecnologia/$tecnologiaId'
    );
  }
}