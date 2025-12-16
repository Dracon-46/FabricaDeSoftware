import 'package:fabrica_software_app/models/projeto.dart';

class ProjetoDTO {
  // Identificador (Nulo = Criação, Preenchido = Edição)
  int? id; 

  // Informações Gerais
  String? nome;
  String? descricao;
  String? modelo; // Ex: SaaS, Marketplace
  String? tipo;   // Web, Mobile, Desktop
  Map<String, dynamic>? cliente;
  String? metodologia;
  
  // Requisitos & Escopo
  String? escopo;
  List<Map<String, dynamic>> requisitos = [];

  // Tecnologias
  List<Map<String, dynamic>> tecnologias = [];

  // Alocação
  List<Map<String, dynamic>> equipe = [];
  List<Map<String, dynamic>> recursos = [];

  // Planejamento & IA
  DateTime? dataInicio;
  DateTime? dataFinalPrevista;
  double? orcamentoEstimado;
  String? complexidade; // DTO usa String para facilitar nos inputs

  // --- LIMPAR (Para criar novo) ---
  void clear() {
    id = null; 
    nome = null;
    descricao = null;
    modelo = null;
    tipo = null;
    cliente = null;
    metodologia = null;
    escopo = null;
    tecnologias = [];
    equipe = [];
    recursos = [];
    requisitos = [];
    dataInicio = null;
    dataFinalPrevista = null;
    orcamentoEstimado = null;
    complexidade = null;
  }

  // --- CARREGAR DADOS (Para Editar) ---
  void loadFromModel(Projeto p) {
    id = p.id;
    nome = p.nomeProjeto;
    descricao = p.descricao;
    
    // --- CORREÇÃO DO ERRO DO DROPDOWN ---
    // Tentamos casar o valor do banco com a lista do Dropdown
    // Se no banco estiver "WEB" e no dropdown "Web", ele corrige para "Web".
    tipo = _normalizarOpcao(p.tipo, ['Web', 'Mobile', 'Desktop', 'API', 'Outros']);
    modelo = _normalizarOpcao(p.modeloProjeto, ['SaaS', 'Marketplace', 'E-commerce', 'Institucional', 'Interno']);
    
    escopo = p.escopo;
    dataInicio = p.dataInicio;
    dataFinalPrevista = p.dataFinalPrevisto;
    orcamentoEstimado = p.orcamentoEstimado;
    
    // Converte Enum para String (Se houver erro aqui, ele retorna null e não quebra a tela)
    complexidade = p.complexidade?.name; 

    if (p.clienteId != 0) {
      cliente = {
        'id': p.clienteId,
        'razao_social': p.clienteNome ?? 'Cliente Atual'
      };
    }
  }

  // --- FUNÇÃO MÁGICA PARA EVITAR O ERRO ---
  String? _normalizarOpcao(String? valorBanco, List<String> opcoesDropdown) {
    if (valorBanco == null) return null;
    try {
      // Procura na lista uma opção que seja igual ignorando maiúsculas/minúsculas
      return opcoesDropdown.firstWhere(
        (opcao) => opcao.toUpperCase() == valorBanco.toUpperCase()
      );
    } catch (e) {
      // Se não achar (ex: banco tem "Banana" e dropdown não tem), 
      // retorna null para o campo ficar vazio em vez de travar o App com tela vermelha.
      return null; 
    }
  }
}

// Instância Global
final projetoDraft = ProjetoDTO();