import 'package:fabrica_software_app/Widgets/Modal_de_criacao/components/Modal_step.dart';
import 'package:fabrica_software_app/providers/modal_criacao_projeto_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'components.dart'; // Seus componentes visuais
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

  // Chave global para acessar o estado da tela e validar
  final GlobalKey<_ConfiguracaoContentState> _contentKey = GlobalKey();

  @override
  Widget buildBody(BuildContext context) {
    return _ConfiguracaoContent(key: _contentKey);
  }

  @override
  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              // Só avança se a validação passar e salvar no DTO
              if (_contentKey.currentState != null) {
                if (_contentKey.currentState!.validarESalvar()) {
                  context.read<ModalCriacaoProjetoProvider>().nextIndex();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2962FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              children: const [
                Text('Próxima etapa'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
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
  // Controladores de Texto
  final _nomeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController(); // Ex: SaaS, B2B
  final _metodologiaCtrl = TextEditingController();
  
  // Listas vindas do Banco de Dados
  List<dynamic> _listaClientesDB = [];
  List<dynamic> _listaTecnologiasDB = [];

  // Variáveis de Seleção
  Map<String, dynamic>? _clienteSelecionado;
  List<Map<String, dynamic>> _tecnologiasSelecionadas = [];
  
  // Campo Tipo (Dropdown estático ou vindo do banco se preferir, aqui fiz estático)
  String? _tipoSelecionado;
  final List<String> _opcoesTipo = ['Web', 'Mobile', 'Desktop', 'API/Backend', 'Híbrido', 'Outro'];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    try {
      // Busca dados reais do Backend em paralelo
      final results = await Future.wait([
        ApiService.getClientes(),
        ApiService.getTecnologias()
      ]);

      if (mounted) {
        setState(() {
          _listaClientesDB = results[0];
          _listaTecnologiasDB = results[1];

          // --- PERSISTÊNCIA: Restaurar dados do DTO se o usuário voltou ---
          if (projetoDraft.nome != null) _nomeCtrl.text = projetoDraft.nome!;
          if (projetoDraft.descricao != null) _descCtrl.text = projetoDraft.descricao!;
          if (projetoDraft.modelo != null) _modeloCtrl.text = projetoDraft.modelo!;
          if (projetoDraft.metodologia != null) _metodologiaCtrl.text = projetoDraft.metodologia!;
          if (projetoDraft.tipo != null) _tipoSelecionado = projetoDraft.tipo;

          // Restaurar Cliente (Busca pelo ID na lista carregada para manter o objeto correto)
          if (projetoDraft.cliente != null) {
            try {
              _clienteSelecionado = _listaClientesDB.firstWhere(
                (c) => c['id'] == projetoDraft.cliente!['id']
              );
            } catch (_) {
              // Cliente não existe mais na lista ou erro de busca
            }
          }

          // Restaurar Tecnologias
          if (projetoDraft.tecnologias.isNotEmpty) {
            _tecnologiasSelecionadas = List.from(projetoDraft.tecnologias);
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar dados: $e"), backgroundColor: Colors.red)
        );
      }
    }
  }

  // Função chamada pelo botão "Próxima Etapa"
  bool validarESalvar() {
    // 1. Validações
    if (_nomeCtrl.text.trim().isEmpty) {
      _showError('O Nome do projeto é obrigatório.');
      return false;
    }
    if (_tipoSelecionado == null) {
      _showError('Selecione o Tipo do projeto (Web, Mobile...).');
      return false;
    }
    if (_clienteSelecionado == null) {
      _showError('Selecione um Cliente para o projeto.');
      return false;
    }
    if (_tecnologiasSelecionadas.isEmpty) {
      _showError('Selecione pelo menos uma Tecnologia.');
      return false;
    }

    // 2. Salvar no DTO Global
    projetoDraft.nome = _nomeCtrl.text;
    projetoDraft.descricao = _descCtrl.text;
    projetoDraft.modelo = _modeloCtrl.text;
    projetoDraft.tipo = _tipoSelecionado; // Salva o Tipo
    projetoDraft.cliente = _clienteSelecionado;
    projetoDraft.metodologia = _metodologiaCtrl.text;
    projetoDraft.tecnologias = _tecnologiasSelecionadas;

    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red)
    );
  }

  // Modal para Multi-seleção de Tecnologias
  void _abrirSelecaoTecnologias() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Selecionar Tecnologias"),
          content: SizedBox(
            width: double.maxFinite,
            child: _listaTecnologiasDB.isEmpty 
              ? const Text("Nenhuma tecnologia cadastrada no banco.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listaTecnologiasDB.length,
                  itemBuilder: (ctx, i) {
                    final tech = _listaTecnologiasDB[i];
                    // Verifica se já está selecionado
                    final isSelected = _tecnologiasSelecionadas.any((t) => t['id'] == tech['id']);
                    
                    return CheckboxListTile(
                      title: Text(tech['nome']),
                      subtitle: tech['categoria'] != null ? Text(tech['categoria']) : null,
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            if (!_tecnologiasSelecionadas.any((t) => t['id'] == tech['id'])) {
                              _tecnologiasSelecionadas.add(tech);
                            }
                          } else {
                            _tecnologiasSelecionadas.removeWhere((t) => t['id'] == tech['id']);
                          }
                        });
                        // Reconstrói apenas o diálogo para atualizar o checkbox visualmente
                        (ctx as Element).markNeedsBuild();
                      },
                    );
                  },
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Concluir"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HEADER "Informações Gerais"
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFF2962FF), size: 20),
              SizedBox(width: 10),
              Text(
                "Informações Gerais",
                style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 1. NOME
        ComponentsConfiguracaoInicalProjeto.buildLabel("Nome do projeto", isRequired: true),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          child: TextField(
            controller: _nomeCtrl,
            decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Ex: Sistema de Gestão ERP"),
          ),
        ),
        const SizedBox(height: 16),

        // 2. TIPO (Dropdown)
        ComponentsConfiguracaoInicalProjeto.buildLabel("Tipo", isRequired: true),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text("Selecione (Web, Mobile...)", style: TextStyle(color: Colors.grey, fontSize: 13)),
              value: _tipoSelecionado,
              isExpanded: true,
              items: _opcoesTipo.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (val) => setState(() => _tipoSelecionado = val),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. MODELO DE NEGÓCIO
        ComponentsConfiguracaoInicalProjeto.buildLabel("Modelo de Negócio", isRequired: false),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          child: TextField(
            controller: _modeloCtrl,
            decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Ex: SaaS, B2B, Marketplace"),
          ),
        ),
        const SizedBox(height: 16),

        // 4. DESCRIÇÃO
        ComponentsConfiguracaoInicalProjeto.buildLabel("Descrição"),
        Container(
          decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
          child: TextField(
            controller: _descCtrl,
            maxLines: 4,
            decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Descreva brevemente o objetivo..."),
          ),
        ),
        const SizedBox(height: 16),

        // 5. CLIENTE E METODOLOGIA
        Row(
          children: [
            // Dropdown de Cliente
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
                        hint: const Text("Selecione...", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        value: _clienteSelecionado,
                        isExpanded: true,
                        items: _listaClientesDB.map((c) {
                          return DropdownMenuItem<dynamic>(
                            value: c, // Objeto completo
                            child: Text(
                              c['razao_social'] ?? 'Sem Nome',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _clienteSelecionado = val),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Campo de Metodologia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComponentsConfiguracaoInicalProjeto.buildLabel("Metodologia"),
                  Container(
                    decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                    child: TextField(
                      controller: _metodologiaCtrl,
                      decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Ex: Scrum, Kanban"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 6. TECNOLOGIAS (Multi-Select)
        ComponentsConfiguracaoInicalProjeto.buildLabel("Tecnologias Utilizadas", isRequired: true),
        GestureDetector(
          onTap: _abrirSelecaoTecnologias,
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
            child: _tecnologiasSelecionadas.isEmpty
                ? const Text("Toque para selecionar...", style: TextStyle(color: Colors.grey, fontSize: 13))
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _tecnologiasSelecionadas.map((t) => Chip(
                      label: Text(t['nome'], style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.blue[50],
                      deleteIcon: const Icon(Icons.close, size: 12, color: Colors.blue),
                      onDeleted: () {
                         setState(() {
                           _tecnologiasSelecionadas.removeWhere((item) => item['id'] == t['id']);
                         });
                      },
                    )).toList(),
                  ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}