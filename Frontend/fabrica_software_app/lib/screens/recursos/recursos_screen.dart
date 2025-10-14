import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recurso.dart';
import '../../providers/recursos_provider.dart';
import '../components/crud_screen.dart';
import 'widgets/recurso_form.dart';
import 'widgets/recurso_list_item.dart';

class RecursosScreen extends StatelessWidget {
  const RecursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecursosProvider>(
      builder: (context, provider, _) {
        return CrudScreen<Recurso>(
          title: 'Recursos',
          items: provider.recursos,
          isLoading: provider.isLoading,
          error: provider.error,
          onRefresh: provider.carregarRecursos,
          onAdd: (recurso) => provider.criarRecurso(recurso.toJson()),
          onUpdate: (recurso) => provider.atualizarRecurso(recurso.id!, recurso.toJson()),
          onDelete: (id) => provider.excluirRecurso(int.parse(id)),
          itemBuilder: (context, recurso) => RecursoListItem(recurso: recurso),
          formBuilder: (context, {Recurso? item}) => RecursoForm(
            recurso: item,
            onSubmit: (recurso) => item == null
                ? provider.criarRecurso(recurso.toJson())
                : provider.atualizarRecurso(item.id!, recurso.toJson()),
          ),
        );
      },
    );
  }
}