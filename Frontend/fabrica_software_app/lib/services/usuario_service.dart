import '../models/usuario.dart';
import 'base_api_service.dart';

class UsuarioService extends BaseApiService {
  UsuarioService() : super('/usuarios');

  Future<List<Usuario>> getUsuarios() async {
    return getAll<Usuario>(Usuario.fromJson);
  }

  Future<Usuario> getUsuario(int id) async {
    return getById<Usuario>(id, Usuario.fromJson);
  }

  Future<Usuario> createUsuario(Usuario usuario) async {
    return create<Usuario>(usuario.toJson(), Usuario.fromJson);
  }

  Future<Usuario> updateUsuario(Usuario usuario) async {
    return update<Usuario>(usuario.id ?? 0, usuario.toJson(), Usuario.fromJson);
  }

  Future<void> deleteUsuario(int id) async {
    return delete(id);
  }
}