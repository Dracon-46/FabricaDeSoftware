import '../models/projeto.dart';
import 'base_api_service.dart';

class ProjetoService extends BaseApiService {
  ProjetoService() : super('/projetos');

  Future<List<Projeto>> getProjetos() async {
    return getAll<Projeto>(Projeto.fromJson);
  }

  Future<Projeto> getProjeto(int id) async {
    return getById<Projeto>(id, Projeto.fromJson);
  }

  Future<Projeto> createProjeto(Projeto projeto) async {
    return create<Projeto>(projeto.toJson(), Projeto.fromJson);
  }

  Future<Projeto> updateProjeto(Projeto projeto) async {
    return update<Projeto>(projeto.id ?? 0, projeto.toJson(), Projeto.fromJson);
  }

  Future<void> deleteProjeto(int id) async {
    return delete(id);
  }
}