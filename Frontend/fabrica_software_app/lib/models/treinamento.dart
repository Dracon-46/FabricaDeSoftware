class Treinamento {
  final int? id;
  final String nome;
  final String? descricao;
  final String? tipoTreinamento;
  final DateTime? dataInicio;
  final DateTime? dataTermino;
  final int? duracaoHoras;
  final String? instrutor;
  final int projetoId;
  final int? criadoPorId;
  final int? documentoId;

  Treinamento({
    this.id,
    required this.nome,
    this.descricao,
    this.tipoTreinamento,
    this.dataInicio,
    this.dataTermino,
    this.duracaoHoras,
    this.instrutor,
    required this.projetoId,
    this.criadoPorId,
    this.documentoId,
  });

  factory Treinamento.fromJson(Map<String, dynamic> json) {
    return Treinamento(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      tipoTreinamento: json['tipo_treinamento'],
      dataInicio: json['data_inicio'] != null 
          ? DateTime.parse(json['data_inicio']) 
          : null,
      dataTermino: json['data_termino'] != null 
          ? DateTime.parse(json['data_termino']) 
          : null,
      duracaoHoras: json['duracao_horas'],
      instrutor: json['instrutor'],
      projetoId: json['projeto_id'],
      criadoPorId: json['criado_por_id'],
      documentoId: json['documento_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipo_treinamento': tipoTreinamento,
      'data_inicio': dataInicio?.toIso8601String(),
      'data_termino': dataTermino?.toIso8601String(),
      'duracao_horas': duracaoHoras,
      'instrutor': instrutor,
      'projeto_id': projetoId,
      'criado_por_id': criadoPorId,
      'documento_id': documentoId,
    };
  }

  Treinamento copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? tipoTreinamento,
    DateTime? dataInicio,
    DateTime? dataTermino,
    int? duracaoHoras,
    String? instrutor,
    int? projetoId,
    int? criadoPorId,
    int? documentoId,
  }) {
    return Treinamento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipoTreinamento: tipoTreinamento ?? this.tipoTreinamento,
      dataInicio: dataInicio ?? this.dataInicio,
      dataTermino: dataTermino ?? this.dataTermino,
      duracaoHoras: duracaoHoras ?? this.duracaoHoras,
      instrutor: instrutor ?? this.instrutor,
      projetoId: projetoId ?? this.projetoId,
      criadoPorId: criadoPorId ?? this.criadoPorId,
      documentoId: documentoId ?? this.documentoId,
    );
  }
}