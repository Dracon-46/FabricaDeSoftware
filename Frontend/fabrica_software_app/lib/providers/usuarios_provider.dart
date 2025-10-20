import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class UsuariosProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);
  List<Usuario> _usuarios = [];
  bool _isLoading = false;
  String? _error;
  Usuario? _usuarioLogado;
  Usuario? _usuarioSelecionado;

  Usuario? get usuarioLogado => _usuarioLogado;
  Usuario? get usuarioSelecionado => _usuarioSelecionado;

  List<Usuario> get usuarios => [..._usuarios];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> carregarUsuarios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.usuarios);
      _usuarios = (response['data'] as List)
          .map((item) => Usuario.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarUsuario(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConfig.usuarios,
        data,
      );
      final novoUsuario = Usuario.fromJson(response['data']);
      _usuarios.add(novoUsuario);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarUsuario(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.put(
        '${ApiConfig.usuarios}/$id',
        data,
      );
      final response = await _apiService.get('${ApiConfig.usuarios}/$id');
      final usuarioAtualizado = Usuario.fromJson(response['data']);
      final index = _usuarios.indexWhere((u) => u.id == id);
      if (index != -1) {
        _usuarios[index] = usuarioAtualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> excluirUsuario(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.delete('${ApiConfig.usuarios}/$id');
      _usuarios.removeWhere((u) => u.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Métodos de compatibilidade para manter a API antiga
  Future<void> fetchUsuarios() => carregarUsuarios();
  Future<void> addUsuario(Usuario usuario) => criarUsuario(usuario.toJson());
  Future<void> updateUsuario(Usuario usuario) => atualizarUsuario(usuario.id!, usuario.toJson());
  Future<void> deleteUsuario(String id) => excluirUsuario(int.parse(id));

  Future<void> setUsuarioLogado(Usuario usuario) async {
    _usuarioLogado = usuario;
    notifyListeners();
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