class Recurso {
  final int? id;
  final String nome;
  final String tipo;
  final bool disponivel;
  final String? descricao;
  final DateTime? dataCriacao;
  final int? criadoPorId;

  Recurso({
    this.id,
    required this.nome,
    required this.tipo,
    this.disponivel = true,
    this.descricao,
    this.dataCriacao,
    this.criadoPorId,
  });

  factory Recurso.fromJson(Map<String, dynamic> json) {
    return Recurso(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      disponivel: json['disponivel'] ?? true,
      descricao: json['descricao'],
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
      criadoPorId: json['criado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'disponivel': disponivel,
      'descricao': descricao,
      'data_criacao': dataCriacao?.toIso8601String(),
      'criado_por_id': criadoPorId,
    };
  }

  Recurso copyWith({
    int? id,
    String? nome,
    String? tipo,
    bool? disponivel,
    String? descricao,
    DateTime? dataCriacao,
    int? criadoPorId,
  }) {
    return Recurso(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      disponivel: disponivel ?? this.disponivel,
      descricao: descricao ?? this.descricao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      criadoPorId: criadoPorId ?? this.criadoPorId,
    );
  }
}