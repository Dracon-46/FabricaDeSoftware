import '../models/requisito.dart';
import 'base_api_service.dart';

class RequisitoService extends BaseApiService {
  RequisitoService() : super('/requisitos');

  Future<List<Requisito>> getRequisitos() async {
    return getAll<Requisito>(Requisito.fromJson);
  }

  Future<Requisito> getRequisito(int id) async {
    return getById<Requisito>(id, Requisito.fromJson);
  }

  Future<Requisito> createRequisito(Requisito requisito) async {
    return create<Requisito>(requisito.toJson(), Requisito.fromJson);
  }

  Future<Requisito> updateRequisito(Requisito requisito) async {
    return update<Requisito>(requisito.id ?? 0, requisito.toJson(), Requisito.fromJson);
  }

  Future<void> deleteRequisito(int id) async {
    return delete(id);
  }
}