import 'package:flutter/material.dart';
import '../models/tecnologia.dart';
import '../services/api_service.dart';

class TecnologiasProvider with ChangeNotifier {
  final List<Tecnologia> _tecnologias = [];
  bool _isLoading = false;
  String? _error;

  List<Tecnologia> get tecnologias => [..._tecnologias];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTecnologias() async {
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

  Future<void> addTecnologia(Tecnologia tecnologia) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _tecnologias.add(tecnologia);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTecnologia(Tecnologia tecnologia) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      final index = _tecnologias.indexWhere((t) => t.id == tecnologia.id);
      if (index != -1) {
        _tecnologias[index] = tecnologia;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTecnologia(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implementar chamada à API
      _tecnologias.removeWhere((t) => t.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}