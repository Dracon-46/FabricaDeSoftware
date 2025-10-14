import 'package:flutter/material.dart';
import '../../../models/contribuidor.dart';

class ContribuidorForm extends StatefulWidget {
  final Contribuidor? contribuidor;

  const ContribuidorForm({
    super.key,
    this.contribuidor,
  });

  @override
  State<ContribuidorForm> createState() => _ContribuidorFormState();
}

class _ContribuidorFormState extends State<ContribuidorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cargoController;
  late final TextEditingController _empresaController;
  late bool _ativo;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contribuidor?.nome ?? '');
    _emailController = TextEditingController(text: widget.contribuidor?.email ?? '');
    _telefoneController = TextEditingController(text: widget.contribuidor?.telefone ?? '');
    _cargoController = TextEditingController(text: widget.contribuidor?.cargo ?? '');
    _empresaController = TextEditingController(text: widget.contribuidor?.empresa ?? '');
    _ativo = widget.contribuidor?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cargoController.dispose();
    _empresaController.dispose();
    super.dispose();
  }

  Contribuidor _getContribuidor() {
    return Contribuidor(
      id: widget.contribuidor?.id,
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      cargo: _cargoController.text,
      empresa: _empresaController.text,
      ativo: _ativo,
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
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome';
              }
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
            controller: _cargoController,
            decoration: const InputDecoration(
              labelText: 'Cargo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _empresaController,
            decoration: const InputDecoration(
              labelText: 'Empresa',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Ativo'),
            value: _ativo,
            onChanged: (value) {
              setState(() {
                _ativo = value;
              });
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
                    Navigator.of(context).pop(_getContribuidor());
                  }
                },
                child: Text(widget.contribuidor == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}