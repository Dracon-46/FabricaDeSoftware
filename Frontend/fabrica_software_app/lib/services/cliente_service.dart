import '../models/cliente.dart';
import 'base_api_service.dart';

class ClienteService extends BaseApiService {
  ClienteService() : super('/clientes');

  Future<List<Cliente>> getClientes() async {
    return getAll<Cliente>(Cliente.fromJson);
  }

  Future<Cliente> getCliente(int id) async {
    return getById<Cliente>(id, Cliente.fromJson);
  }

  Future<Cliente> createCliente(Cliente cliente) async {
    return create<Cliente>(cliente.toJson(), Cliente.fromJson);
  }

  Future<Cliente> updateCliente(Cliente cliente) async {
    return update<Cliente>(cliente.id ?? 0, cliente.toJson(), Cliente.fromJson);
  }

  Future<void> deleteCliente(int id) async {
    return delete(id);
  }
}