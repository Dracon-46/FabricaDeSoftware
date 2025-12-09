class ProjetoDTO {
  // Informações Gerais
  String? nome;
  String? descricao;
  String? modelo; // Ex: SaaS, Marketplace
  String? tipo;   // NOVO: Web, Mobile, Desktop
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
  String? complexidade;

  void clear() {
    nome = null;
    descricao = null;
    modelo = null;
    tipo = null; // Limpa o tipo
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
}

final projetoDraft = ProjetoDTO();