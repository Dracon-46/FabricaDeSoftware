import '../models/log.dart';
import 'base_api_service.dart';

class LogsService extends BaseApiService {
  static final LogsService instance = LogsService._();
  
  LogsService._() : super('/logs');

  Future<List<Log>> listarLogs() async {
    return super.getAll((json) => Log.fromJson(json));
  }

  Future<Log> buscarLog(int id) async {
    return super.getById(id, (json) => Log.fromJson(json));
  }

  Future<Log> criarLog(Map<String, dynamic> data) async {
    return super.create(data, (json) => Log.fromJson(json));
  }

  // Não permite atualização ou exclusão de logs
  
  // Métodos específicos para logs
  Future<List<Log>> buscarPorTipo(String tipo) async {
    return super.getAll(
      (json) => Log.fromJson(json),
      path: '/tipo/$tipo'
    );
  }

  Future<List<Log>> buscarPorUsuario(int usuarioId) async {
    return super.getAll(
      (json) => Log.fromJson(json),
      path: '/usuario/$usuarioId'
    );
  }

  Future<List<Log>> buscarPorPeriodo(DateTime inicio, DateTime fim) async {
    final inicioStr = inicio.toIso8601String();
    final fimStr = fim.toIso8601String();
    
    return super.getAll(
      (json) => Log.fromJson(json),
      path: '/periodo?inicio=$inicioStr&fim=$fimStr'
    );
  }

  Future<List<Log>> buscarPorEntidade(String entidade, int entidadeId) async {
    return super.getAll(
      (json) => Log.fromJson(json),
      path: '/entidade/$entidade/$entidadeId'
    );
  }
}