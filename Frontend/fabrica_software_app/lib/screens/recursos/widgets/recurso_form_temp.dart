import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/recurso.dart';
import '../../../providers/recursos_provider.dart';

class RecursoForm extends StatefulWidget {
  final int? recursoId;

  const RecursoForm({Key? key, this.recursoId}) : super(key: key);

  @override
  State<RecursoForm> createState() => _RecursoFormState();
}

class _RecursoFormState extends State<RecursoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _tipoController;
  late final TextEditingController _descricaoController;
  late bool _disponivel;
  bool _isLoading = false;
  Recurso? _recurso;

  @override
  void initState() {
    super.initState();
    if (widget.recursoId != null) {
      _recurso = Provider.of<RecursosProvider>(context, listen: false)
          .recursos
          .firstWhere((r) => r.id == widget.recursoId);
    }
    
    _nomeController = TextEditingController(text: _recurso?.nome ?? '');
    _tipoController = TextEditingController(text: _recurso?.tipo ?? '');
    _descricaoController = TextEditingController(text: _recurso?.descricao ?? '');
    _disponivel = _recurso?.disponivel ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getRecursoData() {
    return {
      'nome': _nomeController.text,
      'tipo': _tipoController.text,
      'disponivel': _disponivel,
      'descricao': _descricaoController.text.isEmpty ? null : _descricaoController.text,
    };
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_recurso != null) {
        await Provider.of<RecursosProvider>(context, listen: false)
            .atualizarRecurso(_recurso!.id, _getRecursoData());
      } else {
        await Provider.of<RecursosProvider>(context, listen: false)
            .criarRecurso(_getRecursoData());
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _recurso != null ? 'Editar Recurso' : 'Novo Recurso',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
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
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _salvar,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_recurso != null ? 'Atualizar' : 'Criar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}