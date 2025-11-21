import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TecnologiaRow extends StatelessWidget {
  final String nome;
  final String categoria;
  final String descricao;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TecnologiaRow(
    {super.key,
    required this.nome,
    required this.categoria,
    required this.descricao,
    this.onView,
    this.onEdit,
    this.onDelete,}
    );

  @override
  Widget build(BuildContext context) {
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
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(pegarIniciais(nome), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(nome, style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          Expanded(
            flex: 2, 
            child: Chip(
              label: Text(categoria, style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
              backgroundColor: Colors.grey.withOpacity(0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          Expanded(flex: 4, child: Text(descricao, maxLines: 1, overflow: TextOverflow.ellipsis)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: const FaIcon(FontAwesomeIcons.solidEye), onPressed: onView, tooltip: 'Ver', iconSize: 20, color: Colors.blue),
                IconButton(icon: const FaIcon(FontAwesomeIcons.solidPenToSquare), onPressed: onEdit, tooltip: 'Editar', iconSize: 20, color: Colors.orange),
                IconButton(icon: const FaIcon(FontAwesomeIcons.trash), onPressed: onDelete, tooltip: 'Excluir', iconSize: 20, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String pegarIniciais(String nome) {
    nome = nome.trim();
    if (nome.isEmpty) return '?';

    var partes = nome.split(RegExp(r'\s+'));

    if (partes.length == 1) {
      return partes[0][0].toUpperCase();
    }

    String primeira = partes.first[0].toUpperCase();
    String ultima = partes.last[0].toUpperCase();

    return '$primeira$ultima';
  }
}