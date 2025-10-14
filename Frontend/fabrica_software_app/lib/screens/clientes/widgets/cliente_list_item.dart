import 'package:flutter/material.dart';
import '../../../models/cliente.dart';

class ClienteListItem extends StatelessWidget {
  final Cliente cliente;

  const ClienteListItem({
    super.key,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cliente.razaoSocial),
      subtitle: Text('${cliente.cnpj} - ${cliente.email}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement edit
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete
            },
          ),
        ],
      ),
    );
  }
}