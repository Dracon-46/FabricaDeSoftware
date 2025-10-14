import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';

class ListaUsuariosScreen extends StatefulWidget {
  const ListaUsuariosScreen({super.key});

  @override
  State<ListaUsuariosScreen> createState() => _ListaUsuariosScreenState();
}

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega os usuários quando a tela é iniciada
    Future.microtask(() =>
        Provider.of<UsuarioProvider>(context, listen: false).loadUsuarios());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),
      body: Consumer<UsuarioProvider>(
        builder: (context, usuarioProvider, child) {
          if (usuarioProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (usuarioProvider.error != null) {
            return Center(child: Text('Erro: ${usuarioProvider.error}'));
          }

          if (usuarioProvider.usuarios.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }

          return ListView.builder(
            itemCount: usuarioProvider.usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarioProvider.usuarios[index];
              return ListTile(
                title: Text(usuario.nome),
                subtitle: Text(usuario.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implementar edição
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Confirmação antes de deletar
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Deseja realmente excluir este usuário?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                              TextButton(
                                child: const Text('Excluir'),
                                onPressed: () {
                                  usuarioProvider.deleteUsuario(usuario.id!);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Implementar adição de novo usuário
        },
      ),
    );
  }
}