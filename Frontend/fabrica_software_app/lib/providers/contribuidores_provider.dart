import 'package:flutter/material.dart';
import '../models/contribuidor.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ContribuidoresProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);
  List<Contribuidor> _contribuidores = [];
  bool _isLoading = false;
  String? _error;

  List<Contribuidor> get contribuidores => [..._contribuidores];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> carregarContribuidores() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.contribuidores);
      _contribuidores = (response['data'] as List)
          .map((item) => Contribuidor.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarContribuidor(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConfig.contribuidores,
        data,
      );
      final novoContribuidor = Contribuidor.fromJson(response['data']);
      _contribuidores.add(novoContribuidor);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarContribuidor(int? id, Map<String, dynamic> data) async {
    if (id == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.put(
        '${ApiConfig.contribuidores}/$id',
        data,
      );
      final response = await _apiService.get('${ApiConfig.contribuidores}/$id');
      final contribuidorAtualizado = Contribuidor.fromJson(response['data']);
      final index = _contribuidores.indexWhere((c) => c.id == id);
      if (index != -1) {
        _contribuidores[index] = contribuidorAtualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> excluirContribuidor(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.delete('${ApiConfig.contribuidores}/$id');
      _contribuidores.removeWhere((c) => c.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}