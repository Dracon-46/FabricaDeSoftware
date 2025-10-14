import '../models/usuario.dart';
import 'base_api_service.dart';

class UsuariosService extends BaseApiService {
  static final UsuariosService instance = UsuariosService._();
  
  UsuariosService._() : super('/usuarios');

  Future<List<Usuario>> listarUsuarios() async {
    return super.getAll((json) => Usuario.fromJson(json));
  }

  Future<Usuario> buscarUsuario(int id) async {
    return super.getById(id, (json) => Usuario.fromJson(json));
  }

  Future<Usuario> criarUsuario(Map<String, dynamic> data) async {
    return super.create(data, (json) => Usuario.fromJson(json));
  }

  Future<Usuario> atualizarUsuario(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Usuario.fromJson(json));
  }

  Future<void> excluirUsuario(int id) async {
    return super.delete(id);
  }
}