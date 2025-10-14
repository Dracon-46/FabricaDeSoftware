class ContribuidorProjeto {
  final int contribuidorId;
  final int projetoId;
  final DateTime dataInicio;
  final DateTime? dataFim;

  ContribuidorProjeto({
    required this.contribuidorId,
    required this.projetoId,
    required this.dataInicio,
    this.dataFim,
  });

  factory ContribuidorProjeto.fromJson(Map<String, dynamic> json) {
    return ContribuidorProjeto(
      contribuidorId: json['contribuidor_id'],
      projetoId: json['projeto_id'],
      dataInicio: DateTime.parse(json['data_inicio']),
      dataFim: json['data_fim'] != null 
          ? DateTime.parse(json['data_fim']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contribuidor_id': contribuidorId,
      'projeto_id': projetoId,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
    };
  }

  ContribuidorProjeto copyWith({
    int? contribuidorId,
    int? projetoId,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) {
    return ContribuidorProjeto(
      contribuidorId: contribuidorId ?? this.contribuidorId,
      projetoId: projetoId ?? this.projetoId,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
    );
  }
}