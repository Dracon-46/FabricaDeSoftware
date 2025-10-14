import '../models/treinamento.dart';
import 'base_api_service.dart';

class TreinamentosService extends BaseApiService {
  static final TreinamentosService instance = TreinamentosService._();
  
  TreinamentosService._() : super('/treinamentos');

  Future<List<Treinamento>> listarTreinamentos() async {
    return super.getAll((json) => Treinamento.fromJson(json));
  }

  Future<Treinamento> buscarTreinamento(int id) async {
    return super.getById(id, (json) => Treinamento.fromJson(json));
  }

  Future<Treinamento> criarTreinamento(Map<String, dynamic> data) async {
    return super.create(data, (json) => Treinamento.fromJson(json));
  }

  Future<Treinamento> atualizarTreinamento(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Treinamento.fromJson(json));
  }

  Future<void> excluirTreinamento(int id) async {
    return super.delete(id);
  }

  // Métodos específicos para treinamentos
  Future<List<Treinamento>> listarPorTecnologia(int tecnologiaId) async {
    return super.getAll(
      (json) => Treinamento.fromJson(json),
      path: '/tecnologia/$tecnologiaId'
    );
  }

  Future<List<Treinamento>> listarPorUsuario(int usuarioId) async {
    return super.getAll(
      (json) => Treinamento.fromJson(json),
      path: '/usuario/$usuarioId'
    );
  }

  Future<List<Treinamento>> listarPorStatus(String status) async {
    return super.getAll(
      (json) => Treinamento.fromJson(json),
      path: '/status/$status'
    );
  }

  Future<void> marcarComoConcluido(int id) async {
    await super.update(id, {
      'status': 'concluido',
      'dataConclusao': DateTime.now().toIso8601String(),
    }, (json) => Treinamento.fromJson(json));
  }

  Future<void> registrarAvaliacao(int id, double nota, String comentario) async {
    await super.update(id, {
      'avaliacao': {
        'nota': nota,
        'comentario': comentario,
        'data': DateTime.now().toIso8601String(),
      }
    }, (json) => Treinamento.fromJson(json));
  }
}