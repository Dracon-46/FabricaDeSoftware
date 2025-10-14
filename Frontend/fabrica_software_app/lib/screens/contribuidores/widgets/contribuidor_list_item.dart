import 'package:flutter/material.dart';
import '../../../models/contribuidor.dart';

class ContribuidorListItem extends StatelessWidget {
  final Contribuidor contribuidor;

  const ContribuidorListItem({
    super.key,
    required this.contribuidor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contribuidor.nome),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contribuidor.email),
          if (contribuidor.cargo != null && contribuidor.empresa != null)
            Text('${contribuidor.cargo} - ${contribuidor.empresa}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            contribuidor.ativo ? Icons.check_circle : Icons.cancel,
            color: contribuidor.ativo ? Colors.green : Colors.red,
          ),
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