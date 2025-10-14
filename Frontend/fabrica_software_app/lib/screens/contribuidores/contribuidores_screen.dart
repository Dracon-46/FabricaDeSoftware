import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/contribuidor.dart';
import '../../providers/contribuidores_provider.dart';
import '../components/crud_screen.dart';
import 'widgets/contribuidor_form.dart';
import 'widgets/contribuidor_list_item.dart';

class ContribuidoresScreen extends StatelessWidget {
  const ContribuidoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContribuidoresProvider>(
      builder: (context, provider, _) {
        return CrudScreen<Contribuidor>(
          title: 'Contribuidores',
          items: provider.contribuidores ?? [],
          isLoading: provider.isLoading,
          error: provider.error,
          onRefresh: () => provider.carregarContribuidores(),
          onAdd: (contribuidor) async {
            await provider.criarContribuidor(contribuidor.toJson());
          },
          onUpdate: (contribuidor) async {
            await provider.atualizarContribuidor(contribuidor.id, contribuidor.toJson());
          },
          onDelete: (id) async {
            await provider.excluirContribuidor(int.parse(id));
          },
          itemBuilder: (context, contribuidor) => ContribuidorListItem(contribuidor: contribuidor),
          formBuilder: (context, {Contribuidor? item}) => ContribuidorForm(contribuidor: item),
        );
      },
    );
  }
}