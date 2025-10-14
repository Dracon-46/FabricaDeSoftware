import '../models/requisito_projeto.dart';
import 'base_api_service.dart';

class RequisitosProjetoService extends BaseApiService {
  static final RequisitosProjetoService instance = RequisitosProjetoService._();
  
  RequisitosProjetoService._() : super('/requisitos-projeto');

  // Operações básicas CRUD
  Future<List<RequisitoProjeto>> listarRequisitosProjeto() async {
    return super.getAll((json) => RequisitoProjeto.fromJson(json));
  }

  Future<RequisitoProjeto> buscarRequisitoProjeto(int id) async {
    return super.getById(id, (json) => RequisitoProjeto.fromJson(json));
  }

  Future<RequisitoProjeto> adicionarRequisitoProjeto(Map<String, dynamic> data) async {
    return super.create(data, (json) => RequisitoProjeto.fromJson(json));
  }

  Future<RequisitoProjeto> atualizarRequisitoProjeto(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => RequisitoProjeto.fromJson(json));
  }

  Future<void> removerRequisitoProjeto(int id) async {
    return super.delete(id);
  }

  // Operações específicas de relacionamento
  Future<List<RequisitoProjeto>> listarPorProjeto(int projetoId) async {
    return super.getAll(
      (json) => RequisitoProjeto.fromJson(json),
      path: '/projeto/$projetoId'
    );
  }

  Future<List<RequisitoProjeto>> listarPorRequisito(int requisitoId) async {
    return super.getAll(
      (json) => RequisitoProjeto.fromJson(json),
      path: '/requisito/$requisitoId'
    );
  }

  // Métodos específicos de requisitos
  Future<void> marcarComoConcluido(int id) async {
    await super.update(id, {'status': 'concluido'}, (json) => RequisitoProjeto.fromJson(json));
  }

  Future<void> marcarComoEmProgresso(int id) async {
    await super.update(id, {'status': 'em_progresso'}, (json) => RequisitoProjeto.fromJson(json));
  }

  Future<List<RequisitoProjeto>> listarPorStatus(int projetoId, String status) async {
    return super.getAll(
      (json) => RequisitoProjeto.fromJson(json),
      path: '/projeto/$projetoId/status/$status'
    );
  }
}