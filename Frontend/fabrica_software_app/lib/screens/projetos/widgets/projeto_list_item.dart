import 'package:flutter/material.dart';
import '../../../models/projeto.dart';
import '../../../models/enums.dart';

class ProjetoListItem extends StatelessWidget {
  final Projeto projeto;

  const ProjetoListItem({
    super.key,
    required this.projeto,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(projeto.nomeProjeto),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(projeto.descricao ?? 'Sem descrição'),
          Text(
            'Início: ${projeto.dataInicio?.toString().split(' ')[0] ?? 'Não definido'} - '
            'Previsão: ${projeto.dataFinalPrevisto?.toString().split(' ')[0] ?? 'Não definido'}',
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit callback will be handled by CrudScreen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Delete callback will be handled by CrudScreen
            },
          ),
        ],
      ),
    );
  }
}