import 'package:flutter/foundation.dart';
import '../models/projeto.dart';
import '../services/projetos_service.dart';

class ProjetosProvider with ChangeNotifier {
  final _service = ProjetosService.instance;
  bool _isLoading = false;
  String? _error;
  List<Projeto>? _projetos;
  Projeto? _projetoSelecionado;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Projeto>? get projetos => _projetos;
  Projeto? get projetoSelecionado => _projetoSelecionado;

  Future<void> carregarProjetos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projetos = await _service.listarProjetos();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarProjeto(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projetoSelecionado = await _service.buscarProjeto(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarProjeto(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final projeto = await _service.criarProjeto(data);
      _projetos?.add(projeto);
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

  Future<bool> atualizarProjeto(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final projeto = await _service.atualizarProjeto(id, data);
      final index = _projetos?.indexWhere((p) => p.id == id);
      if (index != null && index != -1) {
        _projetos?[index] = projeto;
      }
      if (_projetoSelecionado?.id == id) {
        _projetoSelecionado = projeto;
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

  Future<bool> excluirProjeto(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.excluirProjeto(id);
      _projetos?.removeWhere((p) => p.id == id);
      if (_projetoSelecionado?.id == id) {
        _projetoSelecionado = null;
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

  void limparProjetoSelecionado() {
    _projetoSelecionado = null;
    notifyListeners();
  }
}