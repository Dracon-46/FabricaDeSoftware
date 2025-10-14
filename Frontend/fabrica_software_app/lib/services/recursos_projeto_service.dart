import '../models/recurso_projeto.dart';
import 'base_api_service.dart';

class RecursosProjetoService extends BaseApiService {
  static final RecursosProjetoService instance = RecursosProjetoService._();
  
  RecursosProjetoService._() : super('/recursos-projeto');

  // Operações básicas CRUD
  Future<List<RecursoProjeto>> listarRecursosProjeto() async {
    return super.getAll((json) => RecursoProjeto.fromJson(json));
  }

  Future<RecursoProjeto> buscarRecursoProjeto(int id) async {
    return super.getById(id, (json) => RecursoProjeto.fromJson(json));
  }

  Future<RecursoProjeto> adicionarRecursoProjeto(Map<String, dynamic> data) async {
    return super.create(data, (json) => RecursoProjeto.fromJson(json));
  }

  Future<RecursoProjeto> atualizarRecursoProjeto(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => RecursoProjeto.fromJson(json));
  }

  Future<void> removerRecursoProjeto(int id) async {
    return super.delete(id);
  }

  // Operações específicas de relacionamento
  Future<List<RecursoProjeto>> listarPorProjeto(int projetoId) async {
    return super.getAll(
      (json) => RecursoProjeto.fromJson(json),
      path: '/projeto/$projetoId'
    );
  }

  Future<List<RecursoProjeto>> listarPorRecurso(int recursoId) async {
    return super.getAll(
      (json) => RecursoProjeto.fromJson(json),
      path: '/recurso/$recursoId'
    );
  }
}