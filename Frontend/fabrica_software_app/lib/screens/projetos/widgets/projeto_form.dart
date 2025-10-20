import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/projeto.dart';
import '../../../models/enums.dart';
import '../../../providers/clientes_provider.dart';
import '../../../providers/usuarios_provider.dart';

class ProjetoForm extends StatefulWidget {
  final Projeto? projeto;

  const ProjetoForm({
    super.key,
    this.projeto,
  });

  @override
  State<ProjetoForm> createState() => _ProjetoFormState();
}

class _ProjetoFormState extends State<ProjetoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeProjetoController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _modeloProjetoController;
  late final TextEditingController _metodologiaController;
  late final TextEditingController _escopoController;
  late final TextEditingController _orcamentoController;
  DateTime? _dataInicio;
  DateTime? _dataFinalPrevisto;
  ComplexidadeProjeto? _complexidade;
  int? _clienteId;
  int? _responsavelId;

  @override
  void initState() {
    super.initState();
    _nomeProjetoController = TextEditingController(text: widget.projeto?.nomeProjeto ?? '');
    _descricaoController = TextEditingController(text: widget.projeto?.descricao ?? '');
    _modeloProjetoController = TextEditingController(text: widget.projeto?.modeloProjeto ?? '');
    _metodologiaController = TextEditingController(text: widget.projeto?.metodologia ?? '');
    _escopoController = TextEditingController(text: widget.projeto?.escopo ?? '');
    _orcamentoController = TextEditingController(
      text: widget.projeto?.orcamentoEstimado?.toString() ?? '',
    );
    _dataInicio = widget.projeto?.dataInicio;
    _dataFinalPrevisto = widget.projeto?.dataFinalPrevisto;
    _complexidade = widget.projeto?.complexidade ?? ComplexidadeProjeto.media;
    _clienteId = widget.projeto?.clienteId;
    _responsavelId = widget.projeto?.responsavelId;
  }

  @override
  void dispose() {
    _nomeProjetoController.dispose();
    _descricaoController.dispose();
    _modeloProjetoController.dispose();
    _metodologiaController.dispose();
    _escopoController.dispose();
    _orcamentoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context, bool isDataInicio) async {
    final data = await showDatePicker(
      context: context,
      initialDate: isDataInicio ? _dataInicio ?? DateTime.now() : _dataFinalPrevisto ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        if (isDataInicio) {
          _dataInicio = data;
        } else {
          _dataFinalPrevisto = data;
        }
      });
    }
  }

  Projeto _getProjeto() {
    return Projeto(
      id: widget.projeto?.id,
      nomeProjeto: _nomeProjetoController.text,
      descricao: _descricaoController.text,
      modeloProjeto: _modeloProjetoController.text,
      metodologia: _metodologiaController.text,
      escopo: _escopoController.text,
      dataInicio: _dataInicio,
      dataFinalPrevisto: _dataFinalPrevisto,
      complexidade: _complexidade,
      orcamentoEstimado: double.tryParse(_orcamentoController.text),
      clienteId: _clienteId ?? 0,
      responsavelId: _responsavelId,
      criadoPorId: context.read<UsuariosProvider>().usuarioLogado?.id ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = context.watch<ClientesProvider>();
    final usuariosProvider = context.watch<UsuariosProvider>();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeProjetoController,
              decoration: const InputDecoration(
                labelText: 'Nome do Projeto',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome do projeto';
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
            TextFormField(
              controller: _modeloProjetoController,
              decoration: const InputDecoration(
                labelText: 'Modelo do Projeto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _metodologiaController,
              decoration: const InputDecoration(
                labelText: 'Metodologia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _escopoController,
              decoration: const InputDecoration(
                labelText: 'Escopo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Data de Início'),
                    subtitle: Text(
                      _dataInicio?.toString().split(' ')[0] ?? 'Não definida',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selecionarData(context, true),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Previsão de Conclusão'),
                    subtitle: Text(
                      _dataFinalPrevisto?.toString().split(' ')[0] ?? 'Não definida',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selecionarData(context, false),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ComplexidadeProjeto>(
              value: _complexidade,
              decoration: const InputDecoration(
                labelText: 'Complexidade',
                border: OutlineInputBorder(),
              ),
              items: ComplexidadeProjeto.values.map((complexidade) {
                return DropdownMenuItem(
                  value: complexidade,
                  child: Text(complexidade.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _complexidade = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _orcamentoController,
              decoration: const InputDecoration(
                labelText: 'Orçamento Estimado',
                border: OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _clienteId,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              items: (clientesProvider.clientes ?? []).map((cliente) {
                return DropdownMenuItem(
                  value: cliente.id,
                  child: Text(cliente.razaoSocial),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _clienteId = value);
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione um cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _responsavelId,
              decoration: const InputDecoration(
                labelText: 'Responsável',
                border: OutlineInputBorder(),
              ),
              items: usuariosProvider.usuarios.map((usuario) {
                return DropdownMenuItem(
                  value: usuario.id,
                  child: Text(usuario.nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _responsavelId = value);
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
                      Navigator.of(context).pop(_getProjeto());
                    }
                  },
                  child: Text(widget.projeto == null ? 'Criar' : 'Atualizar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}