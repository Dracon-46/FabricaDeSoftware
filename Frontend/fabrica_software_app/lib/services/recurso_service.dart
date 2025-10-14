import '../models/recurso.dart';
import 'base_api_service.dart';

class RecursoService extends BaseApiService {
  RecursoService() : super('/recursos');

  Future<List<Recurso>> getRecursos() async {
    return getAll<Recurso>(Recurso.fromJson);
  }

  Future<Recurso> getRecurso(int id) async {
    return getById<Recurso>(id, Recurso.fromJson);
  }

  Future<Recurso> createRecurso(Recurso recurso) async {
    return create<Recurso>(recurso.toJson(), Recurso.fromJson);
  }

  Future<Recurso> updateRecurso(Recurso recurso) async {
    return update<Recurso>(recurso.id ?? 0, recurso.toJson(), Recurso.fromJson);
  }

  Future<void> deleteRecurso(int id) async {
    return delete(id);
  }
}