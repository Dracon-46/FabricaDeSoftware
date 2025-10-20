import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/projeto.dart';
import '../../providers/projetos_provider.dart';
import '../components/crud_screen.dart';
import 'widgets/projeto_form.dart';
import 'widgets/projeto_list_item.dart';

class ProjetosScreen extends StatelessWidget {
  const ProjetosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjetosProvider>(
      builder: (context, provider, _) {
        return CrudScreen<Projeto>(
          title: 'Projetos',
          items: provider.projetos,
          isLoading: provider.isLoading,
          error: provider.error,
          onRefresh: () => provider.carregarProjetos(),
          onAdd: (projeto) async {
            await provider.criarProjeto(projeto.toJson());
          },
          onUpdate: (projeto) async {
            if (projeto.id != null) {
              await provider.atualizarProjeto(projeto.id!, projeto.toJson());
            }
          },
          onDelete: (id) async {
            await provider.excluirProjeto(int.parse(id));
          },
          itemBuilder: (context, projeto) => ProjetoListItem(projeto: projeto),
          formBuilder: (context, {Projeto? item}) => ProjetoForm(projeto: item),
        );
      },
    );
  }
}