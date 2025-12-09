import 'package:fabrica_software_app/Widgets/Modal_de_criacao/components/Modal_step.dart';
import 'package:fabrica_software_app/providers/modal_criacao_projeto_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'components.dart';
import 'package:fabrica_software_app/config/projeto_dto.dart';
import 'package:fabrica_software_app/services/api_service.dart';

class ConfiguracaoInicialProjetoStep extends ModalStep {
  @override
  String get title => 'Configuração inicial do projeto';
  @override
  String get tabName => 'Informações Gerais';
  @override
  IconData get icon => FontAwesomeIcons.gears;
  @override
  List<Color> get cores => <Color>[const Color.fromARGB(255, 4, 187, 233)];

  final GlobalKey<_ConfiguracaoContentState> _contentKey = GlobalKey();

  @override
  Widget buildBody(BuildContext context) => _ConfiguracaoContent(key: _contentKey);

  @override
  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_contentKey.currentState != null && _contentKey.currentState!.validarESalvar()) {
                context.read<ModalCriacaoProjetoProvider>().nextIndex();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2962FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(children: const [Text('Próxima etapa'), SizedBox(width: 8), Icon(Icons.arrow_forward_ios, size: 12)]),
          ),
        ],
      ),
    );
  }
}

class _ConfiguracaoContent extends StatefulWidget {
  const _ConfiguracaoContent({super.key});
  @override
  State<_ConfiguracaoContent> createState() => _ConfiguracaoContentState();
}

class _ConfiguracaoContentState extends State<_ConfiguracaoContent> {
  final _nomeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _metodologiaCtrl = TextEditingController();
  
  List<dynamic> _listaClientesDB = [];
  List<dynamic> _listaTecnologiasDB = [];
  Map<String, dynamic>? _clienteSelecionado;
  List<Map<String, dynamic>> _tecnologiasSelecionadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final results = await Future.wait([ApiService.getClientes(), ApiService.getTecnologias()]);
      if (mounted) {
        setState(() {
          _listaClientesDB = results[0];
          _listaTecnologiasDB = results[1];
          // Restaura dados do DTO se existirem
          if (projetoDraft.nome != null) _nomeCtrl.text = projetoDraft.nome!;
          if (projetoDraft.descricao != null) _descCtrl.text = projetoDraft.descricao!;
          if (projetoDraft.metodologia != null) _metodologiaCtrl.text = projetoDraft.metodologia!;
          if (projetoDraft.cliente != null) {
            try { _clienteSelecionado = _listaClientesDB.firstWhere((c) => c['id'] == projetoDraft.cliente!['id']); } catch (_) {}
          }
          if (projetoDraft.tecnologias.isNotEmpty) {
            _tecnologiasSelecionadas = List.from(projetoDraft.tecnologias);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  bool validarESalvar() {
    if (_nomeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome do projeto é obrigatório.')));
      return false;
    }
    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um Cliente.')));
      return false;
    }
    if (_tecnologiasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione ao menos uma Tecnologia.')));
      return false;
    }

    projetoDraft.nome = _nomeCtrl.text;
    projetoDraft.descricao = _descCtrl.text;
    projetoDraft.cliente = _clienteSelecionado;
    projetoDraft.metodologia = _metodologiaCtrl.text;
    projetoDraft.tecnologias = _tecnologiasSelecionadas;
    return true;
  }

  void _abrirSelecaoTecnologias() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Tecnologias"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _listaTecnologiasDB.length,
              itemBuilder: (ctx, i) {
                final tech = _listaTecnologiasDB[i];
                final isSelected = _tecnologiasSelecionadas.any((t) => t['id'] == tech['id']);
                return CheckboxListTile(
                  title: Text(tech['nome']),
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        if (!_tecnologiasSelecionadas.any((t) => t['id'] == tech['id'])) _tecnologiasSelecionadas.add(tech);
                      } else {
                        _tecnologiasSelecionadas.removeWhere((t) => t['id'] == tech['id']);
                      }
                    });
                    (ctx as Element).markNeedsBuild();
                  },
                );
              },
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ComponentsConfiguracaoInicalProjeto.buildLabel("Nome do projeto", isRequired: true),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          child: TextField(controller: _nomeCtrl, decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Ex: ERP Industrial")),
        ),
        const SizedBox(height: 16),
        ComponentsConfiguracaoInicalProjeto.buildLabel("Descrição"),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          child: TextField(controller: _descCtrl, maxLines: 3, decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Objetivo...")),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComponentsConfiguracaoInicalProjeto.buildLabel("Cliente", isRequired: true),
                  Container(
                    decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        hint: const Text("Selecione..."),
                        value: _clienteSelecionado,
                        isExpanded: true,
                        items: _listaClientesDB.map((c) => DropdownMenuItem(value: c, child: Text(c['razao_social']))).toList(),
                        onChanged: (val) => setState(() => _clienteSelecionado = val),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComponentsConfiguracaoInicalProjeto.buildLabel("Metodologia"),
                  Container(
                    decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                    child: TextField(controller: _metodologiaCtrl, decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Ex: Scrum")),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ComponentsConfiguracaoInicalProjeto.buildLabel("Tecnologias", isRequired: true),
        GestureDetector(
          onTap: _abrirSelecaoTecnologias,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
            child: _tecnologiasSelecionadas.isEmpty 
              ? const Text("Toque para selecionar...", style: TextStyle(color: Colors.grey)) 
              : Wrap(spacing: 8, runSpacing: 4, children: _tecnologiasSelecionadas.map((t) => Chip(
                  label: Text(t['nome'], style: const TextStyle(fontSize: 12)),
                  onDeleted: () => setState(() => _tecnologiasSelecionadas.remove(t)),
                )).toList()),
          ),
        ),
      ],
    );
  }
}