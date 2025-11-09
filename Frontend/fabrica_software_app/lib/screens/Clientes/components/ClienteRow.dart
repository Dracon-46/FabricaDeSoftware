import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClienteRow extends StatelessWidget {
  final String razaoSocial;
  final String CNPJ;
  final String setor;
  final String contato;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClienteRow(
    {super.key,
    required this.CNPJ,
    required this.contato,
    required this.razaoSocial,
    required this.setor,
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
                // 'avatar'
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text('${pegarIniciais(razaoSocial)}', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                // 'nome'
                Expanded(child: Text('$razaoSocial', style: TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          // 'cnpj'
          Expanded(flex: 2, child: Text('$CNPJ')),
          // 'setor'
          Expanded(
            flex: 1,
            child: Chip(
              label: Text('$setor', style: TextStyle(fontSize: 12, color: Colors.blue.shade900)),
              backgroundColor: const Color.fromARGB(255, 51, 243, 33).withOpacity(0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          // 'contato'
          Expanded(flex: 2, child: Text('$contato')),
          // 'projeto'
          Expanded(flex: 1, child: Text('1 Projeto(s)')),
          // 'acoes'
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

  var partes = nome.split(RegExp(r'\s+'));

  if (partes.length == 1) {
    return partes[0][0].toUpperCase();
  }

  String primeira = partes.first[0].toUpperCase();
  String ultima = partes.last[0].toUpperCase();

  return '$primeira$ultima';
}
}