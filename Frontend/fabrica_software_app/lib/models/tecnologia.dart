class Tecnologia {
  final int? id;
  final String nome;
  final String? categoria;
  final String? descricao;

  Tecnologia({
    this.id,
    required this.nome,
    this.categoria,
    this.descricao,
  });

  factory Tecnologia.fromJson(Map<String, dynamic> json) {
    return Tecnologia(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'descricao': descricao,
    };
  }

  Tecnologia copyWith({
    int? id,
    String? nome,
    String? categoria,
    String? descricao,
  }) {
    return Tecnologia(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      descricao: descricao ?? this.descricao,
    );
  }
}