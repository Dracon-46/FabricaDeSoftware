import 'package:flutter/material.dart';
class MenuProvider with ChangeNotifier{
  int _selectedIndex=0;
  getSelectedIndex(){
    return _selectedIndex;
  }
  void selectMenu(int valor){
    _selectedIndex=valor;
    notifyListeners();
  }
}