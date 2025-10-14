import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/usuarios_service.dart';

class UsuariosProvider with ChangeNotifier {
  final _service = UsuariosService.instance;
  bool _isLoading = false;
  String? _error;
  List<Usuario>? _usuarios;
  Usuario? _usuarioSelecionado;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Usuario>? get usuarios => _usuarios;
  Usuario? get usuarioSelecionado => _usuarioSelecionado;

  Future<void> carregarUsuarios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await _service.listarUsuarios();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarUsuario(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuarioSelecionado = await _service.buscarUsuario(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarUsuario(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usuario = await _service.criarUsuario(data);
      _usuarios?.add(usuario);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarUsuario(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usuario = await _service.atualizarUsuario(id, data);
      final index = _usuarios?.indexWhere((u) => u.id == id);
      if (index != null && index != -1) {
        _usuarios?[index] = usuario;
      }
      if (_usuarioSelecionado?.id == id) {
        _usuarioSelecionado = usuario;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> excluirUsuario(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.excluirUsuario(id);
      _usuarios?.removeWhere((u) => u.id == id);
      if (_usuarioSelecionado?.id == id) {
        _usuarioSelecionado = null;
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparErro() {
    _error = null;
    notifyListeners();
  }

  void limparUsuarioSelecionado() {
    _usuarioSelecionado = null;
    notifyListeners();
  }
}