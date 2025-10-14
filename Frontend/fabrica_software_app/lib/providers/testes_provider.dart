import 'package:flutter/material.dart';
import '../models/teste.dart';
import '../services/api_service.dart';

class TestesProvider with ChangeNotifier {
  final List<Teste> _testes = [];
  bool _isLoading = false;
  String? _error;

  List<Teste> get testes => [..._testes];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTestes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Implementar chamada à API
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTeste(Teste teste) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _testes.add(teste);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTeste(Teste teste) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      final index = _testes.indexWhere((t) => t.id == teste.id);
      if (index != -1) {
        _testes[index] = teste;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTeste(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _testes.removeWhere((t) => t.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}