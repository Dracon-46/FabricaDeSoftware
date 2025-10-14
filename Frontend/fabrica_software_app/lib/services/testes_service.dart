import '../models/teste.dart';
import 'base_api_service.dart';

class TestesService extends BaseApiService {
  static final TestesService instance = TestesService._();
  
  TestesService._() : super('/testes');

  Future<List<Teste>> listarTestes() async {
    return super.getAll((json) => Teste.fromJson(json));
  }

  Future<Teste> buscarTeste(int id) async {
    return super.getById(id, (json) => Teste.fromJson(json));
  }

  Future<Teste> criarTeste(Map<String, dynamic> data) async {
    return super.create(data, (json) => Teste.fromJson(json));
  }

  Future<Teste> atualizarTeste(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Teste.fromJson(json));
  }

  Future<void> excluirTeste(int id) async {
    return super.delete(id);
  }

  // Métodos específicos para testes
  Future<List<Teste>> listarPorProjeto(int projetoId) async {
    return super.getAll(
      (json) => Teste.fromJson(json),
      path: '/projeto/$projetoId'
    );
  }

  Future<List<Teste>> listarPorStatus(String status) async {
    return super.getAll(
      (json) => Teste.fromJson(json),
      path: '/status/$status'
    );
  }

  Future<List<Teste>> listarPorResponsavel(int usuarioId) async {
    return super.getAll(
      (json) => Teste.fromJson(json),
      path: '/responsavel/$usuarioId'
    );
  }

  Future<void> marcarComoConcluido(int id, Map<String, dynamic> resultado) async {
    await super.update(id, {
      'status': 'concluido',
      'resultado': resultado,
      'dataConclusao': DateTime.now().toIso8601String(),
    }, (json) => Teste.fromJson(json));
  }

  Future<void> marcarComoFalha(int id, String motivoFalha) async {
    await super.update(id, {
      'status': 'falha',
      'motivoFalha': motivoFalha,
      'dataConclusao': DateTime.now().toIso8601String(),
    }, (json) => Teste.fromJson(json));
  }
}