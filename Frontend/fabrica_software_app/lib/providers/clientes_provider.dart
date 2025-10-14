import 'package:flutter/foundation.dart';
import '../models/cliente.dart';
import '../services/clientes_service.dart';

class ClientesProvider with ChangeNotifier {
  final _service = ClientesService.instance;
  bool _isLoading = false;
  String? _error;
  List<Cliente>? _clientes;
  Cliente? _clienteSelecionado;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Cliente>? get clientes => _clientes;
  Cliente? get clienteSelecionado => _clienteSelecionado;

  Future<void> carregarClientes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clientes = await _service.listarClientes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarCliente(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clienteSelecionado = await _service.buscarCliente(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarCliente(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cliente = await _service.criarCliente(data);
      _clientes?.add(cliente);
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

  Future<bool> atualizarCliente(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cliente = await _service.atualizarCliente(id, data);
      final index = _clientes?.indexWhere((c) => c.id == id);
      if (index != null && index != -1) {
        _clientes?[index] = cliente;
      }
      if (_clienteSelecionado?.id == id) {
        _clienteSelecionado = cliente;
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

  Future<bool> excluirCliente(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.excluirCliente(id);
      _clientes?.removeWhere((c) => c.id == id);
      if (_clienteSelecionado?.id == id) {
        _clienteSelecionado = null;
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

  void limparClienteSelecionado() {
    _clienteSelecionado = null;
    notifyListeners();
  }
}