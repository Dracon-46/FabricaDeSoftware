class ProjetoDTO {
  // Informações Gerais
  String? nome;
  String? descricao;
  Map<String, dynamic>? cliente; // Guarda o objeto cliente inteiro {id, razao_social...}
  String? metodologia;
  
  // Tecnologias (Multi-seleção)
  List<Map<String, dynamic>> tecnologias = []; // Lista de objetos {id, nome...}

  // Alocação
  List<Map<String, dynamic>> equipe = []; // {id, nome, cargo, papel}
  List<Map<String, dynamic>> recursos = []; // {id, nome, tipo}

  // Requisitos
  List<Map<String, dynamic>> requisitos = []; // {titulo, descricao, tipo, prioridade}

  // Planejamento
  DateTime? dataInicio;
  DateTime? dataFinalPrevista;
  double? orcamentoEstimado;

  // Limpa os dados ao finalizar
  void clear() {
    nome = null;
    descricao = null;
    cliente = null;
    metodologia = null;
    tecnologias = [];
    equipe = [];
    recursos = [];
    requisitos = [];
    dataInicio = null;
    dataFinalPrevista = null;
    orcamentoEstimado = null;
  }
}

// Singleton global para acesso em todos os steps
final projetoDraft = ProjetoDTO();