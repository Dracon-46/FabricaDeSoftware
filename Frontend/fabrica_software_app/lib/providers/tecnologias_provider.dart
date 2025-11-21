import 'package:flutter/foundation.dart';
import '../models/tecnologia.dart';
import '../services/tecnologia_service.dart';

class TecnologiasProvider with ChangeNotifier {
  final _service = TecnologiasService.instance;
  bool _isLoading = false;
  String? _error;
  List<Tecnologia>? _tecnologias;
  Tecnologia? _tecnologiaSelecionada;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Tecnologia>? get tecnologias => _tecnologias;
  Tecnologia? get tecnologiaSelecionada => _tecnologiaSelecionada;

  Future<void> carregarTecnologias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tecnologias = await _service.listarTecnologias();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarTecnologia(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tecnologiaSelecionada = await _service.buscarTecnologia(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarTecnologia(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tecnologia = await _service.criarTecnologia(data);
      _tecnologias?.add(tecnologia);
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

  Future<bool> atualizarTecnologia(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tecnologia = await _service.atualizarTecnologia(id, data);
      final index = _tecnologias?.indexWhere((p) => p.id == id);
      if (index != null && index != -1) {
        _tecnologias?[index] = tecnologia;
      }
      if (_tecnologiaSelecionada?.id == id) {
        _tecnologiaSelecionada = tecnologia;
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

  Future<bool> excluirTecnologia(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.excluirTecnologia(id);
      _tecnologias?.removeWhere((p) => p.id == id);
      if (_tecnologiaSelecionada?.id == id) {
        _tecnologiaSelecionada = null;
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

  void limparTecnologiaSelecionada() {
    _tecnologiaSelecionada = null;
    notifyListeners();
  }
}