import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService.instance;
  bool _isLoading = false;
  String? _error;
  bool? _isAuthenticated;
  String? _userNivel;

  AuthProvider() {
    _init();
  }

  bool? get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userNivel => _userNivel;

  Future<void> _init() async {
    _isAuthenticated = await _authService.isAuthenticated;
    _userNivel = await _authService.userNivel;
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, senha);
      _isLoading = false;
      if (!success) {
        _error = 'Credenciais inválidas';
      } else {
        _isAuthenticated = true;
        _userNivel = await _authService.userNivel;
      }
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _userNivel = null;
    notifyListeners();
  }
}