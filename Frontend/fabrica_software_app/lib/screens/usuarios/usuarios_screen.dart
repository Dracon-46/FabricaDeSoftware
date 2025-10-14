import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/usuario.dart';
import '../../providers/usuarios_provider.dart';
import '../components/crud_screen.dart';
import 'widgets/usuario_form.dart';
import 'widgets/usuario_list_item.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuariosProvider>(
      builder: (context, provider, _) {
        return CrudScreen<Usuario>(
          title: 'Usuários',
          items: provider.usuarios ?? [],
          isLoading: provider.isLoading,
          error: provider.error,
          onRefresh: () => provider.carregarUsuarios(),
          onAdd: (usuario) async {
            await provider.criarUsuario(usuario.toJson());
          },
          onUpdate: (usuario) async {
            await provider.atualizarUsuario(usuario.id, usuario.toJson());
          },
          onDelete: (id) async {
            await provider.excluirUsuario(int.parse(id));
          },
          itemBuilder: (context, usuario) => UsuarioListItem(usuario: usuario),
          formBuilder: (context, {Usuario? item}) => UsuarioForm(usuario: item),
        );
      },
    );
  }
}