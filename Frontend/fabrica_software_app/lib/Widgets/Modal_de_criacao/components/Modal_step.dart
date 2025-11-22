import 'package:flutter/material.dart';

abstract class ModalStep {
  String get title;
  IconData get icon;
  String get tabName;
  List<Colors> get cores;
  Widget buildBody(BuildContext context);
  Widget buildFooter(BuildContext context);
}