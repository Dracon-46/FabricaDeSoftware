import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Userrow extends StatelessWidget {
  const Userrow({super.key});

  @override
  Widget build(BuildContext context) {
    // O build deve retornar APENAS o widget da linha
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // 'avatar'
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text('TC', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                // 'nome'
                Expanded(child: Text('TechCorp Solutions', style: TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          // 'cnpj'
          Expanded(flex: 2, child: Text('12.345.678/0001-90')),
          // 'setor'
          Expanded(
            flex: 1,
            child: Chip(
              label: Text('Tecnologia', style: TextStyle(fontSize: 12, color: Colors.blue.shade900)),
              backgroundColor: Colors.blue.withOpacity(0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          // 'contato'
          Expanded(flex: 2, child: Text('contato1@gmail.com')),
          // 'projeto'
          Expanded(flex: 1, child: Text('1 Projeto(s)')),
          // 'acoes'
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(icon: FaIcon(FontAwesomeIcons.solidEye), onPressed: () {}, tooltip: 'Ver', iconSize: 20),
                IconButton(icon: FaIcon(FontAwesomeIcons.solidPenToSquare), onPressed: () {}, tooltip: 'Editar', iconSize: 20),
                IconButton(icon: FaIcon(FontAwesomeIcons.trash, color: Colors.red), onPressed: () {}, tooltip: 'Excluir', iconSize: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}