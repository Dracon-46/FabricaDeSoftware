class Contribuidor {
  final int? id;
  final String nome;
  final String email;
  final String? telefone;
  final String? cargo;
  final String? empresa;
  final bool ativo;

  Contribuidor({
    this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.cargo,
    this.empresa,
    this.ativo = true,
  });

  factory Contribuidor.fromJson(Map<String, dynamic> json) {
    return Contribuidor(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      cargo: json['cargo'],
      empresa: json['empresa'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cargo': cargo,
      'empresa': empresa,
      'ativo': ativo,
    };
  }

  Contribuidor copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? cargo,
    String? empresa,
    bool? ativo,
  }) {
    return Contribuidor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cargo: cargo ?? this.cargo,
      empresa: empresa ?? this.empresa,
      ativo: ativo ?? this.ativo,
    );
  }
}