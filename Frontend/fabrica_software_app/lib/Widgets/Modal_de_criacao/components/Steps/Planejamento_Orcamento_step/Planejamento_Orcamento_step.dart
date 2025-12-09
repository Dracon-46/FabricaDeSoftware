import 'package:fabrica_software_app/Widgets/Modal_de_criacao/components/Modal_step.dart';
import 'package:fabrica_software_app/Widgets/Modal_de_criacao/components/Steps/Configuracao_Inicial_Projeto_step/components.dart';
import 'package:fabrica_software_app/providers/modal_criacao_projeto_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/config/projeto_dto.dart';
import 'package:fabrica_software_app/services/api_service.dart';

class PlanejamentoOrcamentoStep extends ModalStep {
  @override
  String get title => 'Planejamento & Orçamento';
  @override
  String get tabName => 'Finalização';
  @override
  IconData get icon => FontAwesomeIcons.calendarCheck;
  @override
  List<Color> get cores => <Color>[Colors.orangeAccent, Colors.deepOrange];

  final GlobalKey<_PlanejamentoContentState> _contentKey = GlobalKey();

  @override
  Widget buildBody(BuildContext context) {
    return _PlanejamentoContent(key: _contentKey);
  }

  @override
  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              // Regra: Cancelar limpa tudo
              projetoDraft.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  // Regra: Voltar limpa dados desta etapa
                  if (_contentKey.currentState != null) {
                    _contentKey.currentState!.limparEtapa();
                  }
                  context.read<ModalCriacaoProjetoProvider>().previousIndex();
                },
                child: const Text('Voltar', style: TextStyle(color: Colors.black87)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                   if (_contentKey.currentState != null) {
                     await _contentKey.currentState!.finalizarProjeto();
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Row(
                  children: const [
                    Text('CRIAR PROJETO', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.check, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanejamentoContent extends StatefulWidget {
  const _PlanejamentoContent({super.key});

  @override
  State<_PlanejamentoContent> createState() => _PlanejamentoContentState();
}

class _PlanejamentoContentState extends State<_PlanejamentoContent> {
  final _dataInicioCtrl = TextEditingController();
  final _dataFimCtrl = TextEditingController();
  final _orcamentoCtrl = TextEditingController();
  
  DateTime? _dataInicio;
  DateTime? _dataFim;
  
  bool _isCalculatingIA = false;
  bool _isSending = false;

  void limparEtapa() {
    _dataInicioCtrl.clear();
    _dataFimCtrl.clear();
    _orcamentoCtrl.clear();
    projetoDraft.dataInicio = null;
    projetoDraft.dataFinalPrevista = null;
    projetoDraft.orcamentoEstimado = null;
  }

  Future<void> _selectDate(TextEditingController ctrl, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2962FF)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Validação: Data Fim não pode ser menor que Inicio
      if (!isStart && _dataInicio != null && picked.isBefore(_dataInicio!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("A data final não pode ser anterior à data de início."))
        );
        return;
      }
      
      setState(() {
        ctrl.text = DateFormat('dd/MM/yyyy').format(picked);
        if (isStart) _dataInicio = picked;
        else _dataFim = picked;
      });
    }
  }

  // --- IA DINÂMICA NO BACKEND ---
  Future<void> _estimarOrcamentoIA() async {
    if (_dataInicio == null || _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Defina as datas para calcular a duração estimada."))
      );
      return;
    }

    setState(() => _isCalculatingIA = true);

    try {
      final dias = _dataFim!.difference(_dataInicio!).inDays;
      
      // Chama o ApiService que vai no Node.js
      double valor = await ApiService.estimarOrcamentoBackend({
        "nome": projetoDraft.nome,
        "descricao": projetoDraft.descricao,
        "duracao_dias": dias,
        "equipe": projetoDraft.equipe,
        "recursos": projetoDraft.recursos
      });
      
      setState(() {
        _orcamentoCtrl.text = valor.toStringAsFixed(2);
        projetoDraft.orcamentoEstimado = valor;
      });

    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao calcular orçamento."))
      );
    } finally {
      setState(() => _isCalculatingIA = false);
    }
  }

  Future<void> finalizarProjeto() async {
    // VALIDAÇÕES
    if (_dataInicioCtrl.text.isEmpty || _dataFimCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha as datas de início e fim."))
      );
      return;
    }
    if (_orcamentoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O orçamento é obrigatório. Use a IA ou digite."))
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      projetoDraft.dataInicio = _dataInicio;
      projetoDraft.dataFinalPrevista = _dataFim;
      projetoDraft.orcamentoEstimado = double.tryParse(_orcamentoCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

      // Monta Payload para o ApiService
      final Map<String, dynamic> payload = {
        "nome_projeto": projetoDraft.nome,
        "descricao": projetoDraft.descricao,
        "cliente_id": projetoDraft.cliente?['id'],
        "metodologia": projetoDraft.metodologia,
        "data_inicio": projetoDraft.dataInicio?.toIso8601String(),
        "data_final_previsto": projetoDraft.dataFinalPrevista?.toIso8601String(),
        "orcamento_estimado": projetoDraft.orcamentoEstimado,
        "tecnologias": projetoDraft.tecnologias.map((t) => t['id']).toList(),
        "equipe": projetoDraft.equipe.toList(),
        "recursos": projetoDraft.recursos.map((r) => r['id']).toList(),
        "requisitos": projetoDraft.requisitos.toList()
      };

      await ApiService.criarProjetoCompleto(payload);

      if (mounted) {
        Navigator.pop(context); // Fecha Modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Projeto criado com sucesso!"), backgroundColor: Colors.green)
        );
        projetoDraft.clear(); // Limpa rascunho
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSending) {
       return const Center(child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           CircularProgressIndicator(),
           SizedBox(height: 10),
           Text("Criando Projeto no Banco...")
         ],
       ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cabeçalho Interno
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.calendar_month_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 10),
              Text("Planejamento & Orçamento", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ComponentsConfiguracaoInicalProjeto.buildLabel("Data de Início", isRequired: true),
                   GestureDetector(
                     onTap: () => _selectDate(_dataInicioCtrl, true),
                     child: AbsorbPointer(
                       child: Container(
                         decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                         child: TextField(
                           controller: _dataInicioCtrl,
                           decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Selecionar", icon: Icons.calendar_today),
                         ),
                       ),
                     ),
                   ),
                 ],
               )
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ComponentsConfiguracaoInicalProjeto.buildLabel("Data Final Prevista", isRequired: true),
                   GestureDetector(
                     onTap: () => _selectDate(_dataFimCtrl, false),
                     child: AbsorbPointer(
                       child: Container(
                         decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                         child: TextField(
                           controller: _dataFimCtrl,
                           decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("Selecionar", icon: Icons.event),
                         ),
                       ),
                     ),
                   ),
                 ],
               )
             ),
          ],
        ),
        const SizedBox(height: 20),

        ComponentsConfiguracaoInicalProjeto.buildLabel("Orçamento Estimado", isRequired: true),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: ComponentsConfiguracaoInicalProjeto.inputBoxDecoration,
                child: TextField(
                  controller: _orcamentoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: ComponentsConfiguracaoInicalProjeto.inputDecoration("R\$ 0.00"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _isCalculatingIA ? null : _estimarOrcamentoIA,
              icon: _isCalculatingIA 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(FontAwesomeIcons.wandMagicSparkles, size: 16),
              label: const Text("IA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16)
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "O valor pode ser digitado manualmente ou estimado pela Inteligência Artificial com base no escopo e equipe.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}