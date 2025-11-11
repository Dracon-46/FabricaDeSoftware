import '../models/recurso.dart';
import 'base_api_service.dart';

// Este service segue o padrão do seu 'projetos_service.dart',
// aceitando e retornando Maps para ser compatível com o provider.
class RecursosService extends BaseApiService {
  // Tornando um singleton, assim como seu 'projetos_service.dart'
  static final RecursosService instance = RecursosService._();
  
  RecursosService._() : super('/recursos');

  Future<List<Recurso>> listarRecursos() async {
    // O método getAll já retorna uma Lista, parseando o JSON
    return super.getAll((json) => Recurso.fromJson(json));
  }

  Future<Recurso> buscarRecurso(int id) async {
    return super.getById(id, (json) => Recurso.fromJson(json));
  }

  // O modal envia um Map, assim como no seu CRUD de Clientes
  Future<Recurso> criarRecurso(Map<String, dynamic> data) async {
    return super.create(data, (json) => Recurso.fromJson(json));
  }

  Future<Recurso> atualizarRecurso(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Recurso.fromJson(json));
  }

  Future<void> excluirRecurso(int id) async {
    return super.delete(id);
  }
}