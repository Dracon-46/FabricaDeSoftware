import '../models/contribuidor_projeto.dart';
import 'base_api_service.dart';

class ContribuidoresProjetoService extends BaseApiService {
  static final ContribuidoresProjetoService instance = ContribuidoresProjetoService._();
  
  ContribuidoresProjetoService._() : super('/contribuidores-projeto');

  // Operações básicas CRUD
  Future<List<ContribuidorProjeto>> listarContribuidoresProjeto() async {
    return super.getAll((json) => ContribuidorProjeto.fromJson(json));
  }

  Future<ContribuidorProjeto> buscarContribuidorProjeto(int id) async {
    return super.getById(id, (json) => ContribuidorProjeto.fromJson(json));
  }

  Future<ContribuidorProjeto> adicionarContribuidorProjeto(Map<String, dynamic> data) async {
    return super.create(data, (json) => ContribuidorProjeto.fromJson(json));
  }

  Future<ContribuidorProjeto> atualizarContribuidorProjeto(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => ContribuidorProjeto.fromJson(json));
  }

  Future<void> removerContribuidorProjeto(int id) async {
    return super.delete(id);
  }

  // Operações específicas de relacionamento
  Future<List<ContribuidorProjeto>> listarPorProjeto(int projetoId) async {
    final response = await super.getAll(
      (json) => ContribuidorProjeto.fromJson(json),
      path: '/projeto/$projetoId'
    );
    return response;
  }

  Future<List<ContribuidorProjeto>> listarPorContribuidor(int contribuidorId) async {
    final response = await super.getAll(
      (json) => ContribuidorProjeto.fromJson(json),
      path: '/contribuidor/$contribuidorId'
    );
    return response;
  }
}