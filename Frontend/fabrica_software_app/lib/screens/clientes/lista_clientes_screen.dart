import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';
import '../components/crud_screen.dart';
import '../components/crud_form.dart';

class ListaClientesScreen extends StatelessWidget {
  const ListaClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientesProvider>(
      builder: (context, clientesProvider, _) {
        return CrudScreen<Cliente>(
          title: 'Clientes',
          items: clientesProvider.clientes,
          isLoading: clientesProvider.isLoading,
          error: clientesProvider.error,
          onRefresh: () => clientesProvider.fetchClientes(),
          onAdd: (cliente) => clientesProvider.addCliente(cliente),
          onUpdate: (cliente) => clientesProvider.updateCliente(cliente),
          onDelete: (id) => clientesProvider.deleteCliente(id),
          itemBuilder: (context, cliente) => ListTile(
            title: Text(cliente.nome),
            subtitle: Text(cliente.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Editar Cliente'),
                      content: CrudForm(
                        fields: _buildFormFields(),
                        initialData: cliente.toJson(),
                        onSubmit: (data) {
                          final updatedCliente = Cliente.fromJson(data);
                          return clientesProvider.updateCliente(updatedCliente);
                        },
                        isLoading: clientesProvider.isLoading,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar Exclusão'),
                      content: const Text(
                          'Tem certeza que deseja excluir este cliente?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            clientesProvider.deleteCliente(cliente.id);
                          },
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          formBuilder: (context, {Cliente? item}) => CrudForm(
            fields: _buildFormFields(),
            initialData: item?.toJson() ?? {},
            onSubmit: (data) {
              final cliente = Cliente.fromJson(data);
              return item == null
                  ? clientesProvider.addCliente(cliente)
                  : clientesProvider.updateCliente(cliente);
            },
            isLoading: clientesProvider.isLoading,
          ),
        );
      },
    );
  }

  List<FormField> _buildFormFields() {
    return [
      const FormField(
        name: 'nome',
        label: 'Nome',
        validator: _validateRequired,
      ),
      const FormField(
        name: 'email',
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
      ),
      const FormField(
        name: 'telefone',
        label: 'Telefone',
        keyboardType: TextInputType.phone,
        validator: _validateRequired,
      ),
      const FormField(
        name: 'cnpj',
        label: 'CNPJ',
        keyboardType: TextInputType.number,
        validator: _validateRequired,
      ),
    ];
  }

  static String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (!value.contains('@')) {
      return 'Digite um email válido';
    }
    return null;
  }
}