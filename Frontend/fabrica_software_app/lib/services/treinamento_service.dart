import '../models/treinamento.dart';
import 'base_api_service.dart';

class TreinamentoService extends BaseApiService {
  TreinamentoService() : super('/treinamentos');

  Future<List<Treinamento>> getTreinamentos() async {
    return getAll<Treinamento>(Treinamento.fromJson);
  }

  Future<Treinamento> getTreinamento(int id) async {
    return getById<Treinamento>(id, Treinamento.fromJson);
  }

  Future<Treinamento> createTreinamento(Treinamento treinamento) async {
    return create<Treinamento>(treinamento.toJson(), Treinamento.fromJson);
  }

  Future<Treinamento> updateTreinamento(Treinamento treinamento) async {
    return update<Treinamento>(treinamento.id ?? 0, treinamento.toJson(), Treinamento.fromJson);
  }

  Future<void> deleteTreinamento(int id) async {
    return delete(id);
  }
}