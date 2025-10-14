import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider with ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _error;

  List<Usuario> get usuarios => _usuarios;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsuarios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await _usuarioService.getUsuarios();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUsuario(Usuario usuario) async {
    try {
      final newUsuario = await _usuarioService.createUsuario(usuario);
      _usuarios.add(newUsuario);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUsuario(Usuario usuario) async {
    try {
      final updatedUsuario = await _usuarioService.updateUsuario(usuario);
      final index = _usuarios.indexWhere((u) => u.id == usuario.id);
      if (index != -1) {
        _usuarios[index] = updatedUsuario;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteUsuario(int id) async {
    try {
      await _usuarioService.deleteUsuario(id);
      _usuarios.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}