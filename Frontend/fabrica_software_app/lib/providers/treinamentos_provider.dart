import 'package:flutter/material.dart';
import '../models/treinamento.dart';
import '../services/api_service.dart';

class TreinamentosProvider with ChangeNotifier {
  final List<Treinamento> _treinamentos = [];
  bool _isLoading = false;
  String? _error;

  List<Treinamento> get treinamentos => [..._treinamentos];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTreinamentos() async {
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

  Future<void> addTreinamento(Treinamento treinamento) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _treinamentos.add(treinamento);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTreinamento(Treinamento treinamento) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      final index = _treinamentos.indexWhere((t) => t.id == treinamento.id);
      if (index != -1) {
        _treinamentos[index] = treinamento;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTreinamento(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _treinamentos.removeWhere((t) => t.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}