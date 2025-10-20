import 'package:flutter/material.dart';
import '../models/requisito.dart';


class RequisitosProvider with ChangeNotifier {
  final List<Requisito> _requisitos = [];
  bool _isLoading = false;
  String? _error;

  List<Requisito> get requisitos => [..._requisitos];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRequisitos() async {
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

  Future<void> addRequisito(Requisito requisito) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _requisitos.add(requisito);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequisito(Requisito requisito) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      final index = _requisitos.indexWhere((r) => r.id == requisito.id);
      if (index != -1) {
        _requisitos[index] = requisito;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRequisito(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _requisitos.removeWhere((r) => r.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}