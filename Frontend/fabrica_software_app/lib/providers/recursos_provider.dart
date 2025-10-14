import 'package:flutter/material.dart';
import '../models/recurso.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class RecursosProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);
  List<Recurso> _recursos = [];
  bool _isLoading = false;
  String? _error;

  List<Recurso> get recursos => [..._recursos];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> carregarRecursos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.recursos);
      _recursos = (response['data'] as List)
          .map((item) => Recurso.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarRecurso(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConfig.recursos,
        data,
      );
      final novoRecurso = Recurso.fromJson(response['data']);
      _recursos.add(novoRecurso);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarRecurso(int? id, Map<String, dynamic> data) async {
    if (id == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.put(
        '${ApiConfig.recursos}/$id',
        data,
      );
      final response = await _apiService.get('${ApiConfig.recursos}/$id');
      final recursoAtualizado = Recurso.fromJson(response['data']);
      final index = _recursos.indexWhere((r) => r.id == id);
      if (index != -1) {
        _recursos[index] = recursoAtualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> excluirRecurso(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.delete('${ApiConfig.recursos}/$id');
      _recursos.removeWhere((r) => r.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}