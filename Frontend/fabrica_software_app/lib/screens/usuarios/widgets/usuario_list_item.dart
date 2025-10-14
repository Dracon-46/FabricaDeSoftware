import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '../../../models/enums.dart';

class UsuarioListItem extends StatelessWidget {
  final Usuario usuario;

  const UsuarioListItem({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nome),
      subtitle: Text('${usuario.email} - ${usuario.nivel.toString().split('.').last}'),
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