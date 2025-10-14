import '../models/cliente.dart';
import 'base_api_service.dart';

class ClientesService extends BaseApiService {
  static final ClientesService instance = ClientesService._();
  
  ClientesService._() : super('/clientes');

  Future<List<Cliente>> listarClientes() async {
    return super.getAll((json) => Cliente.fromJson(json));
  }

  Future<Cliente> buscarCliente(int id) async {
    return super.getById(id, (json) => Cliente.fromJson(json));
  }

  Future<Cliente> criarCliente(Map<String, dynamic> data) async {
    return super.create(data, (json) => Cliente.fromJson(json));
  }

  Future<Cliente> atualizarCliente(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Cliente.fromJson(json));
  }

  Future<void> excluirCliente(int id) async {
    return super.delete(id);
  }
}