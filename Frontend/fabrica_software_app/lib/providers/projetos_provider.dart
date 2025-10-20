import 'package:flutter/foundation.dart';
import '../models/projeto.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ProjetosProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(baseUrl: ApiConfig.baseUrl);
  List<Projeto> _projetos = [];
  bool _isLoading = false;
  String? _error;
  Projeto? _projetoSelecionado;

  List<Projeto> get projetos => [..._projetos];
  Projeto? get projetoSelecionado => _projetoSelecionado;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> carregarProjetos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.projetos);
      _projetos = (response['data'] as List)
          .map((item) => Projeto.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarProjeto(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        ApiConfig.projetos,
        data,
      );
      final novoProjeto = Projeto.fromJson(response['data']);
      _projetos.add(novoProjeto);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarProjeto(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.put(
        '${ApiConfig.projetos}/$id',
        data,
      );
      final response = await _apiService.get('${ApiConfig.projetos}/$id');
      final projetoAtualizado = Projeto.fromJson(response['data']);
      final index = _projetos.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projetos[index] = projetoAtualizado;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> excluirProjeto(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.delete('${ApiConfig.projetos}/$id');
      _projetos.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparErro() {
    _error = null;
    notifyListeners();
  }

  void limparProjetoSelecionado() {
    _projetoSelecionado = null;
    notifyListeners();
  }
}