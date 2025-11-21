class Endereco {
  final int? id;
  final String logradouro;
  final String cep;
  final String? numero;
  final String? bairro;
  final String cidade;
  final String estado;
  final String pais;
  final String? complemento;

  Endereco({
    this.id,
    required this.logradouro,
    required this.cep,
    this.numero,
    this.bairro,
    required this.cidade,
    required this.estado,
    required this.pais,
    this.complemento,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      // --- CORREÇÃO (Igual ao bug do Cliente) ---
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      logradouro: json['logradouro'],
      cep: json['cep'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      pais: json['pais'],
      complemento: json['complemento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logradouro': logradouro,
      'cep': cep,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'pais': pais,
      'complemento': complemento,
    };
  }

  Endereco copyWith({
    int? id,
    String? logradouro,
    String? cep,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? pais,
    String? complemento,
  }) {
    return Endereco(
      id: id ?? this.id,
      logradouro: logradouro ?? this.logradouro,
      cep: cep ?? this.cep,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
      complemento: complemento ?? this.complemento,
    );
  }
}