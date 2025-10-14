class RecursoProjeto {
  final int recursoId;
  final int projetoId;
  final double? custoHora;
  final DateTime dataAlocacao;
  final DateTime? dataDesalocacao;

  RecursoProjeto({
    required this.recursoId,
    required this.projetoId,
    this.custoHora,
    required this.dataAlocacao,
    this.dataDesalocacao,
  });

  factory RecursoProjeto.fromJson(Map<String, dynamic> json) {
    return RecursoProjeto(
      recursoId: json['recurso_id'],
      projetoId: json['projeto_id'],
      custoHora: json['custo_hora'] != null 
          ? double.parse(json['custo_hora'].toString())
          : null,
      dataAlocacao: DateTime.parse(json['data_alocacao']),
      dataDesalocacao: json['data_desalocacao'] != null 
          ? DateTime.parse(json['data_desalocacao']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recurso_id': recursoId,
      'projeto_id': projetoId,
      'custo_hora': custoHora,
      'data_alocacao': dataAlocacao.toIso8601String(),
      'data_desalocacao': dataDesalocacao?.toIso8601String(),
    };
  }

  RecursoProjeto copyWith({
    int? recursoId,
    int? projetoId,
    double? custoHora,
    DateTime? dataAlocacao,
    DateTime? dataDesalocacao,
  }) {
    return RecursoProjeto(
      recursoId: recursoId ?? this.recursoId,
      projetoId: projetoId ?? this.projetoId,
      custoHora: custoHora ?? this.custoHora,
      dataAlocacao: dataAlocacao ?? this.dataAlocacao,
      dataDesalocacao: dataDesalocacao ?? this.dataDesalocacao,
    );
  }
}