import 'package:flutter/material.dart';

class StyleLogin {

static ButtonStyle btnGoogle = ElevatedButton.styleFrom
  (
    padding: const EdgeInsets.symmetric(vertical: 14),
    foregroundColor: const Color.fromARGB(255, 179, 172, 172),
    backgroundColor: const Color.fromARGB(255, 233, 233, 233),
    side: BorderSide(color: const Color.fromARGB(255, 233, 233, 233)),
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    minimumSize: const Size(double.infinity, 50),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

}