class Requisito {
  final int? id;
  final String tipo;
  final String descricao;
  final String? observacoes;

  Requisito({
    this.id,
    required this.tipo,
    required this.descricao,
    this.observacoes,
  });

  factory Requisito.fromJson(Map<String, dynamic> json) {
    return Requisito(
      id: json['id'],
      tipo: json['tipo'],
      descricao: json['descricao'],
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'descricao': descricao,
      'observacoes': observacoes,
    };
  }

  Requisito copyWith({
    int? id,
    String? tipo,
    String? descricao,
    String? observacoes,
  }) {
    return Requisito(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}