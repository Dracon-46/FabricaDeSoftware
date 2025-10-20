import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';
import '../../models/enums.dart';
import '../../providers/usuarios_provider.dart';
import '../components/crud_screen.dart';

class ListaUsuariosScreen extends StatelessWidget {
  const ListaUsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosProvider>(
      builder: (context, usuariosProvider, _) {
        return CrudScreen<Usuario>(
          title: 'Usuários',
          items: usuariosProvider.usuarios,
          isLoading: usuariosProvider.isLoading,
          error: usuariosProvider.error,
          onRefresh: () => usuariosProvider.fetchUsuarios(),
          onAdd: (usuario) => usuariosProvider.addUsuario(usuario),
          onUpdate: (usuario) => usuariosProvider.updateUsuario(usuario),
          onDelete: (id) => usuariosProvider.deleteUsuario(id),
          itemBuilder: (context, usuario) => ListTile(
            title: Text(usuario.nome),
            subtitle: Text(usuario.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implementar edição
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Implementar exclusão
                  },
                ),
              ],
            ),
          ),
          formBuilder: (context, {Usuario? item}) {
            final nomeController = TextEditingController(text: item?.nome);
            final emailController = TextEditingController(text: item?.email);
            final senhaController = TextEditingController();

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (item == null) ...[
                    TextField(
                      controller: senhaController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final usuario = Usuario(
                            id: item?.id,
                            nome: nomeController.text,
                            email: emailController.text,
                            nivel: NivelUsuario.admin, // Valor padrão, ajuste conforme necessário
                            senha: senhaController.text,
                          );
                          if (item == null) {
                            usuariosProvider.addUsuario(usuario);
                          } else {
                            usuariosProvider.updateUsuario(usuario);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(item == null ? 'Criar' : 'Atualizar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}