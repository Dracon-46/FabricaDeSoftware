import 'package:flutter/material.dart';
import '../../../models/recurso.dart';

class RecursoListItem extends StatelessWidget {
  final Recurso recurso;
  
  const RecursoListItem({
    super.key,
    required this.recurso,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(recurso.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${recurso.tipo}'),
            if (recurso.descricao != null)
              Text(recurso.descricao!),
            Row(
              children: [
                Icon(
                  recurso.disponivel ? Icons.check_circle : Icons.cancel,
                  color: recurso.disponivel ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  recurso.disponivel ? 'Disponível' : 'Indisponível',
                  style: TextStyle(
                    color: recurso.disponivel ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Editar Recurso'),
                  content: const Text('Deseja editar este recurso?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          '/recursos/editar',
                          arguments: recurso,
                        );
                      },
                      child: const Text('Editar'),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (recurso.id != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Excluir Recurso'),
                      content: const Text('Deseja excluir este recurso?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recurso excluído com sucesso!'),
                              ),
                            );
                          },
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}