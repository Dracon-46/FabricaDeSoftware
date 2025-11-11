import '../models/tecnologia.dart';
import 'base_api_service.dart';

// Service no padrão do seu 'projetos_service.dart'
class TecnologiasService extends BaseApiService {
  static final TecnologiasService instance = TecnologiasService._();
  
  TecnologiasService._() : super('/tecnologias');

  Future<List<Tecnologia>> listarTecnologias() async {
    return super.getAll((json) => Tecnologia.fromJson(json));
  }

  Future<Tecnologia> buscarTecnologia(int id) async {
    return super.getById(id, (json) => Tecnologia.fromJson(json));
  }

  Future<Tecnologia> criarTecnologia(Map<String, dynamic> data) async {
    return super.create(data, (json) => Tecnologia.fromJson(json));
  }

  Future<Tecnologia> atualizarTecnologia(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Tecnologia.fromJson(json));
  }

  Future<void> excluirTecnologia(int id) async {
    return super.delete(id);
  }
}