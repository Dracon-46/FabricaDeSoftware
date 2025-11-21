import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService.instance;
  bool _isLoading = false;
  String? _error;
  bool? _isAuthenticated;
  String? _userNivel;
  String? _email;
  String? _nome;

  AuthProvider() {
    _init();
  }

  bool? get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userNivel => _userNivel;
  String? get email => _email;
  String? get nome => _nome;

  Future<void> _init() async {
    _isAuthenticated = await _authService.isAuthenticated;
    _userNivel = await _authService.userNivel;
    // Você pode pré-carregar nome e email aqui se o usuário já estiver logado
    if (_isAuthenticated ?? false) {
      _email = await _authService.userEmail;
      _nome = await _authService.userName;
    }
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
        _email = email; // No login normal, pegamos o email do input
        _nome = await _authService.userName;
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

  // --- MÉTODO CORRIGIDO ---
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.loginWithGoogle();
      _isLoading = false;
      if (!success) {
        _error = 'Falha no login com Google.';
      } else {
        _isAuthenticated = true;
        _userNivel = await _authService.userNivel;
        // --- ESTA É A CORREÇÃO ---
        _email = await _authService.userEmail; // Pega o email
        _nome = await _authService.userName;  // Pega o nome
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
  // --- FIM DO MÉTODO ---

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _userNivel = null;
    _email = null; 
    _nome = null;
    notifyListeners();
  }
}