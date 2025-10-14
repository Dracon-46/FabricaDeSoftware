import 'package:flutter/material.dart';
import '../../../models/recurso.dart';

class RecursoForm extends StatefulWidget {
  final Recurso? recurso;
  final Function(Recurso) onSubmit;

  const RecursoForm({
    Key? key,
    this.recurso,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<RecursoForm> createState() => _RecursoFormState();
}

class _RecursoFormState extends State<RecursoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _tipoController;
  late final TextEditingController _descricaoController;
  late bool _disponivel;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.recurso?.nome ?? '');
    _tipoController = TextEditingController(text: widget.recurso?.tipo ?? '');
    _descricaoController = TextEditingController(text: widget.recurso?.descricao ?? '');
    _disponivel = widget.recurso?.disponivel ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final recurso = Recurso(
      id: widget.recurso?.id,
      nome: _nomeController.text,
      tipo: _tipoController.text,
      descricao: _descricaoController.text.isEmpty ? null : _descricaoController.text,
      disponivel: _disponivel,
    );

    widget.onSubmit(recurso);
    Navigator.of(context).pop();
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
            controller: _tipoController,
            decoration: const InputDecoration(
              labelText: 'Tipo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o tipo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Disponível'),
            value: _disponivel,
            onChanged: (value) => setState(() => _disponivel = value),
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
                onPressed: _submit,
                child: Text(widget.recurso != null ? 'Atualizar' : 'Criar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}