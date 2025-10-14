class Cliente {
  final int? id;
  final String razaoSocial;
  final String cnpj;
  final String email;
  final String? telefone;
  final String? setor;
  final String? contato;
  final DateTime? dataCriacao;
  final int enderecoId;

  Cliente({
    this.id,
    required this.razaoSocial,
    required this.cnpj,
    required this.email,
    this.telefone,
    this.setor,
    this.contato,
    this.dataCriacao,
    required this.enderecoId,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      razaoSocial: json['razao_social'],
      cnpj: json['cnpj'],
      email: json['email'],
      telefone: json['telefone'],
      setor: json['setor'],
      contato: json['contato'],
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
      enderecoId: json['endereco_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'razao_social': razaoSocial,
      'cnpj': cnpj,
      'email': email,
      'telefone': telefone,
      'setor': setor,
      'contato': contato,
      'data_criacao': dataCriacao?.toIso8601String(),
      'endereco_id': enderecoId,
    };
  }

  Cliente copyWith({
    int? id,
    String? razaoSocial,
    String? cnpj,
    String? email,
    String? telefone,
    String? setor,
    String? contato,
    DateTime? dataCriacao,
    int? enderecoId,
  }) {
    return Cliente(
      id: id ?? this.id,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      cnpj: cnpj ?? this.cnpj,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      setor: setor ?? this.setor,
      contato: contato ?? this.contato,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      enderecoId: enderecoId ?? this.enderecoId,
    );
  }
}