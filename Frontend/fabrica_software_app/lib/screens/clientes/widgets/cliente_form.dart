import 'package:flutter/material.dart';
import '../../../models/cliente.dart';

class ClienteForm extends StatefulWidget {
  final Cliente? cliente;

  const ClienteForm({
    super.key,
    this.cliente,
  });

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _razaoSocialController;
  late final TextEditingController _cnpjController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _setorController;
  late final TextEditingController _contatoController;
  late final TextEditingController _enderecoIdController;

  @override
  void initState() {
    super.initState();
    _razaoSocialController = TextEditingController(text: widget.cliente?.razaoSocial ?? '');
    _cnpjController = TextEditingController(text: widget.cliente?.cnpj ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
    _telefoneController = TextEditingController(text: widget.cliente?.telefone ?? '');
    _setorController = TextEditingController(text: widget.cliente?.setor ?? '');
    _contatoController = TextEditingController(text: widget.cliente?.contato ?? '');
    _enderecoIdController = TextEditingController(text: widget.cliente?.enderecoId.toString() ?? '');
  }

  @override
  void dispose() {
    _razaoSocialController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _setorController.dispose();
    _contatoController.dispose();
    _enderecoIdController.dispose();
    super.dispose();
  }

  Cliente _getCliente() {
    return Cliente(
      id: widget.cliente?.id,
      razaoSocial: _razaoSocialController.text,
      cnpj: _cnpjController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      setor: _setorController.text,
      contato: _contatoController.text,
      enderecoId: int.tryParse(_enderecoIdController.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _razaoSocialController,
            decoration: const InputDecoration(
              labelText: 'Razão Social',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a razão social';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cnpjController,
            decoration: const InputDecoration(
              labelText: 'CNPJ',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o CNPJ';
              }
              // Add CNPJ validation if needed
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o email';
              }
              if (!value.contains('@')) {
                return 'Por favor, insira um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telefoneController,
            decoration: const InputDecoration(
              labelText: 'Telefone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _setorController,
            decoration: const InputDecoration(
              labelText: 'Setor',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contatoController,
            decoration: const InputDecoration(
              labelText: 'Contato',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _enderecoIdController,
            decoration: const InputDecoration(
              labelText: 'ID do Endereço',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o ID do endereço';
              }
              if (int.tryParse(value) == null) {
                return 'Por favor, insira um número válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).pop(_getCliente());
                  }
                },
                child: Text(widget.cliente == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}