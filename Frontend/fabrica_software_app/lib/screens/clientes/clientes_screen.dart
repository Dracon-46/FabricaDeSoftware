import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';
import '../components/crud_screen.dart';
import 'widgets/cliente_form.dart';
import 'widgets/cliente_list_item.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientesProvider>(
      builder: (context, provider, _) {
        return CrudScreen<Cliente>(
          title: 'Clientes',
          items: provider.clientes ?? [],
          isLoading: provider.isLoading,
          error: provider.error,
          onRefresh: () => provider.carregarClientes(),
          onAdd: (cliente) async {
            await provider.criarCliente(cliente.toJson());
          },
          onUpdate: (cliente) async {
            if (cliente.id != null) {
              await provider.atualizarCliente(cliente.id!, cliente.toJson());
            }
          },
          onDelete: (id) async {
            await provider.excluirCliente(int.parse(id));
          },
          itemBuilder: (context, cliente) => ClienteListItem(cliente: cliente),
          formBuilder: (context, {Cliente? item}) => ClienteForm(cliente: item),
        );
      },
    );
  }
}