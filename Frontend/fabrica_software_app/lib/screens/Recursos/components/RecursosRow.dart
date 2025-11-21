import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecursoRow extends StatelessWidget {
  final String nome;
  final String tipo;
  final bool disponivel;
  final String descricao;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RecursoRow(
    {super.key,
    required this.nome,
    required this.tipo,
    required this.disponivel,
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
                // Avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.purple.withOpacity(0.1),
                  child: Text(pegarIniciais(nome), style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                // Nome
                Expanded(child: Text(nome, style: TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          // Tipo
          Expanded(flex: 2, child: Text(tipo)),
          // Disponível
          Expanded(
            flex: 1,
            child: Chip(
              label: Text(disponivel ? 'Sim' : 'Não', style: TextStyle(fontSize: 12, color: disponivel ? Colors.green.shade900 : Colors.red.shade900)),
              backgroundColor: (disponivel ? Colors.green : Colors.red).withOpacity(0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          // Descrição (resumida)
          Expanded(
            flex: 2, 
            child: Text(
              descricao, 
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ),
          // Ações
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(icon: FaIcon(FontAwesomeIcons.solidEye), onPressed: onView, tooltip: 'Ver', iconSize: 20),
                IconButton(icon: FaIcon(FontAwesomeIcons.solidPenToSquare), onPressed: onEdit, tooltip: 'Editar', iconSize: 20),
                IconButton(icon: FaIcon(FontAwesomeIcons.trash, color: Colors.red), onPressed: onDelete, tooltip: 'Excluir', iconSize: 20),
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