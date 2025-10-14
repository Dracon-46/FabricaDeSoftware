import 'enums.dart';

class Usuario {
  final int? id;
  final String nome;
  final String email;
  final NivelUsuario nivel;
  final String? telefone;
  final String? senha; // Usado apenas para criação/edição

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.nivel,
    this.telefone,
    this.senha,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      nivel: NivelUsuario.fromString(json['nivel']),
      telefone: json['telefone'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'nome': nome,
      'email': email,
      'nivel': nivel.toString().split('.').last,
      'telefone': telefone,
    };

    if (senha != null) {
      data['senha'] = senha;
    }

    return data;
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    NivelUsuario? nivel,
    String? telefone,
    String? senha,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      nivel: nivel ?? this.nivel,
      telefone: telefone ?? this.telefone,
      senha: senha ?? this.senha,
    );
  }
}