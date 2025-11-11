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
    // Função auxiliar para converter de String/int para int?
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Recurso(
      // CORREÇÃO: Usamos o _parseInt para converter com segurança
      id: _parseInt(json['id']),
      
      nome: json['nome'],
      tipo: json['tipo'],
      disponivel: json['disponivel'] ?? true,
      descricao: json['descricao'],
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
          
      // CORREÇÃO: Usamos o _parseInt aqui também
      criadoPorId: _parseInt(json['criado_por_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'disponivel': disponivel,
      'descricao': descricao,
      // data_criacao é gerenciada pelo banco
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