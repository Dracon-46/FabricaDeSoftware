import 'package:flutter/foundation.dart';
import '../models/endereco.dart';
import '../services/enderecos_service.dart';

class EnderecosProvider with ChangeNotifier {
  final _service = EnderecosService.instance;
  bool _isLoading = false;
  String? _error;
  List<Endereco>? _enderecos;
  Endereco? _enderecoSelecionado;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Endereco>? get enderecos => _enderecos;
  Endereco? get enderecoSelecionado => _enderecoSelecionado;

  // Busca um único endereço (útil para o modal)
  // Retorna o Endereco para o modal usar
  Future<Endereco> buscarEndereco(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endereco = await _service.buscarEndereco(id);
      _enderecoSelecionado = endereco;
      return endereco;
    } catch (e) {
      _error = e.toString();
      rethrow; // Lança o erro para o modal poder tratar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cria um novo endereço e retorna o objeto criado
  Future<Endereco> criarEndereco(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endereco = await _service.criarEndereco(data);
      _enderecos?.add(endereco); // Adiciona na lista local, se ela existir
      _error = null;
      return endereco;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow; // Lança o erro para o modal poder tratar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualiza um endereço e retorna o objeto atualizado
  Future<Endereco> atualizarEndereco(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final endereco = await _service.atualizarEndereco(id, data);
      
      // Atualiza a lista local
      final index = _enderecos?.indexWhere((c) => c.id == id);
      if (index != null && index != -1) {
        _enderecos?[index] = endereco;
      }
      // Atualiza o item selecionado
      if (_enderecoSelecionado?.id == id) {
        _enderecoSelecionado = endereco;
      }
      
      _error = null;
      return endereco;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow; // Lança o erro para o modal poder tratar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // (Você pode adicionar 'carregarEnderecos' (lista) e 'excluirEndereco' depois, se precisar)
}