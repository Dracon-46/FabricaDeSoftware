import '../models/projeto.dart';
import 'base_api_service.dart';

class ProjetosService extends BaseApiService {
  static final ProjetosService instance = ProjetosService._();
  
  ProjetosService._() : super('/projetos');

  Future<List<Projeto>> listarProjetos() async {
    return super.getAll((json) => Projeto.fromJson(json));
  }

  Future<Projeto> buscarProjeto(int id) async {
    return super.getById(id, (json) => Projeto.fromJson(json));
  }

  Future<Projeto> criarProjeto(Map<String, dynamic> data) async {
    return super.create(data, (json) => Projeto.fromJson(json));
  }

  Future<Projeto> atualizarProjeto(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Projeto.fromJson(json));
  }

  Future<void> excluirProjeto(int id) async {
    return super.delete(id);
  }
}