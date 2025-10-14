import 'package:flutter/material.dart';
import '../../../models/usuario.dart';
import '../../../models/enums.dart';

class UsuarioForm extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioForm({
    super.key,
    this.usuario,
  });

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;
  late final TextEditingController _telefoneController;
  late NivelUsuario _nivelSelecionado;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario?.nome ?? '');
    _emailController = TextEditingController(text: widget.usuario?.email ?? '');
    _senhaController = TextEditingController();
    _telefoneController = TextEditingController(text: widget.usuario?.telefone ?? '');
    _nivelSelecionado = widget.usuario?.nivel ?? NivelUsuario.colaborador;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Usuario _getUsuario() {
    return Usuario(
      id: widget.usuario?.id,
      nome: _nomeController.text,
      email: _emailController.text,
      nivel: _nivelSelecionado,
      telefone: _telefoneController.text,
      senha: _senhaController.text.isNotEmpty ? _senhaController.text : null,
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
            controller: _senhaController,
            decoration: InputDecoration(
              labelText: widget.usuario == null ? 'Senha' : 'Nova senha (opcional)',
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (widget.usuario == null && (value == null || value.isEmpty)) {
                return 'Por favor, insira a senha';
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
          DropdownButtonFormField<NivelUsuario>(
            value: _nivelSelecionado,
            decoration: const InputDecoration(
              labelText: 'Nível de Acesso',
              border: OutlineInputBorder(),
            ),
            items: NivelUsuario.values.map((nivel) {
              return DropdownMenuItem(
                value: nivel,
                child: Text(nivel.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _nivelSelecionado = value);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor, selecione o nível de acesso';
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
                    Navigator.of(context).pop(_getUsuario());
                  }
                },
                child: Text(widget.usuario == null ? 'Criar' : 'Atualizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}