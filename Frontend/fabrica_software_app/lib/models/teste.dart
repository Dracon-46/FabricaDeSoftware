class Teste {
  final int? id;
  final String nome;
  final String? descricao;
  final int projetoId;

  Teste({
    this.id,
    required this.nome,
    this.descricao,
    required this.projetoId,
  });

  factory Teste.fromJson(Map<String, dynamic> json) {
    return Teste(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      projetoId: json['projeto_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'projeto_id': projetoId,
    };
  }

  Teste copyWith({
    int? id,
    String? nome,
    String? descricao,
    int? projetoId,
  }) {
    return Teste(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      projetoId: projetoId ?? this.projetoId,
    );
  }
}