import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'base_api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNivelKey = 'user_nivel';
  // 1. NOVO: Chave para guardar o nome no SharedPreferences
  static const String _userNameKey = 'user_name'; 

  String? _cachedToken;
  int? _cachedUserId;
  String? _cachedUserNivel;
  // 2. NOVO: Variável de cache para o nome
  String? _cachedUserName; 
  DateTime? _lastTokenRefresh;

  AuthService._();
  static final AuthService instance = AuthService._();
  
  Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        _cachedToken = json['token'];
        _cachedUserId = json['usuario']['id'];
        _cachedUserNivel = json['usuario']['nivel'];
        // 3. NOVO: Puxe o nome do JSON (ajuste 'nome' se o campo for outro)
        _cachedUserName = json['usuario']['nome']; 
        _lastTokenRefresh = DateTime.now();

        await prefs.setString(_tokenKey, _cachedToken!);
        await prefs.setInt(_userIdKey, _cachedUserId!);
        await prefs.setString(_userNivelKey, _cachedUserNivel!);
        // 4. NOVO: Salve o nome no SharedPreferences
        if (_cachedUserName != null) {
          await prefs.setString(_userNameKey, _cachedUserName!);
        }
        return true;
      }
      return false;
    } catch (e) {
      throw ApiException('Erro ao fazer login: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    _cachedToken = null;
    _cachedUserId = null;
    _cachedUserNivel = null;
    _cachedUserName = null; // 5. NOVO: Limpe o cache do nome
    _lastTokenRefresh = null;

    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNivelKey);
    await prefs.remove(_userNameKey); // 5. NOVO: Remova do SharedPreferences
  }

  Future<bool> get isAuthenticated async {
    final token = await this.token;
    return token != null;
  }
  
  Future<String?> get token async {
    // ... (seu código de refresh do token está ótimo)
    if (_cachedToken != null && _lastTokenRefresh != null) {
      final difference = DateTime.now().difference(_lastTokenRefresh!);
      if (difference.inMinutes < 30) {
        return _cachedToken;
      }
      try {
        await refreshToken();
        return _cachedToken;
      } catch (e) {
        return null;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }
  
  Future<int?> get userId async {
    if (_cachedUserId != null) return _cachedUserId;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getInt(_userIdKey);
    return _cachedUserId;
  }
  
  Future<String?> get userNivel async {
    if (_cachedUserNivel != null) return _cachedUserNivel;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedUserNivel = prefs.getString(_userNivelKey);
    return _cachedUserNivel;
  }

  // 5. NOVO: Getter para o nome de usuário (padrão igual aos outros)
  Future<String?> get userName async {
    if (_cachedUserName != null) return _cachedUserName;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedUserName = prefs.getString(_userNameKey);
    return _cachedUserName;
  }

  Future<bool> refreshToken() async {
    // ... (seu código de refresh está ótimo)
    try {
      final oldToken = _cachedToken;
      if (oldToken == null) return false;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $oldToken',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        _cachedToken = json['token'];
        _lastTokenRefresh = DateTime.now();

        await prefs.setString(_tokenKey, _cachedToken!);
        return true;
      }
      return false;
    } catch (e) {
      throw ApiException('Erro ao renovar token: ${e.toString()}');
    }
  }
}