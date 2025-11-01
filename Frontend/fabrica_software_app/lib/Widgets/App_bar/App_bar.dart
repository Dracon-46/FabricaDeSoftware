import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w700),),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      iconTheme: IconThemeData(
          size: 40,             // Aumentar o tamanho o faz parecer mais "bold"
          weight: 700.0,        // Esta é a propriedade "bold" para ícones
        ),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}