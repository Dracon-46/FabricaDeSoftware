class Log {
  final int? id;
  final String nomeTabela;
  final String? nomeCampo;
  final String chavePrimariaRegistro;
  final String? chaveSecundariaRegistro;
  final String tipoAcao;
  final String? valorAntigo;
  final String? valorNovo;
  final DateTime? dataHora;
  final int? modificadoPorId;

  Log({
    this.id,
    required this.nomeTabela,
    this.nomeCampo,
    required this.chavePrimariaRegistro,
    this.chaveSecundariaRegistro,
    required this.tipoAcao,
    this.valorAntigo,
    this.valorNovo,
    this.dataHora,
    this.modificadoPorId,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      nomeTabela: json['nome_tabela'],
      nomeCampo: json['nome_campo'],
      chavePrimariaRegistro: json['chave_primaria_registro'],
      chaveSecundariaRegistro: json['chave_secundaria_registro'],
      tipoAcao: json['tipo_acao'],
      valorAntigo: json['valor_antigo'],
      valorNovo: json['valor_novo'],
      dataHora: json['data_hora'] != null 
          ? DateTime.parse(json['data_hora']) 
          : null,
      modificadoPorId: json['modificado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_tabela': nomeTabela,
      'nome_campo': nomeCampo,
      'chave_primaria_registro': chavePrimariaRegistro,
      'chave_secundaria_registro': chaveSecundariaRegistro,
      'tipo_acao': tipoAcao,
      'valor_antigo': valorAntigo,
      'valor_novo': valorNovo,
      'data_hora': dataHora?.toIso8601String(),
      'modificado_por_id': modificadoPorId,
    };
  }

  Log copyWith({
    int? id,
    String? nomeTabela,
    String? nomeCampo,
    String? chavePrimariaRegistro,
    String? chaveSecundariaRegistro,
    String? tipoAcao,
    String? valorAntigo,
    String? valorNovo,
    DateTime? dataHora,
    int? modificadoPorId,
  }) {
    return Log(
      id: id ?? this.id,
      nomeTabela: nomeTabela ?? this.nomeTabela,
      nomeCampo: nomeCampo ?? this.nomeCampo,
      chavePrimariaRegistro: chavePrimariaRegistro ?? this.chavePrimariaRegistro,
      chaveSecundariaRegistro: chaveSecundariaRegistro ?? this.chaveSecundariaRegistro,
      tipoAcao: tipoAcao ?? this.tipoAcao,
      valorAntigo: valorAntigo ?? this.valorAntigo,
      valorNovo: valorNovo ?? this.valorNovo,
      dataHora: dataHora ?? this.dataHora,
      modificadoPorId: modificadoPorId ?? this.modificadoPorId,
    );
  }
}