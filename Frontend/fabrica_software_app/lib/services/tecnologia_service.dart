import '../models/tecnologia.dart';
import 'base_api_service.dart';

class TecnologiaService extends BaseApiService {
  TecnologiaService() : super('/tecnologias');

  Future<List<Tecnologia>> getTecnologias() async {
    return getAll<Tecnologia>(Tecnologia.fromJson);
  }

  Future<Tecnologia> getTecnologia(int id) async {
    return getById<Tecnologia>(id, Tecnologia.fromJson);
  }

  Future<Tecnologia> createTecnologia(Tecnologia tecnologia) async {
    return create<Tecnologia>(tecnologia.toJson(), Tecnologia.fromJson);
  }

  Future<Tecnologia> updateTecnologia(Tecnologia tecnologia) async {
    return update<Tecnologia>(tecnologia.id ?? 0, tecnologia.toJson(), Tecnologia.fromJson);
  }

  Future<void> deleteTecnologia(int id) async {
    return delete(id);
  }
}