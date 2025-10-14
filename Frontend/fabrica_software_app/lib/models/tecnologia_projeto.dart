class TecnologiaProjeto {
  final int tecnologiaId;
  final int projetoId;
  final DateTime? dataAprovacao;
  final int? aprovadoPorId;

  TecnologiaProjeto({
    required this.tecnologiaId,
    required this.projetoId,
    this.dataAprovacao,
    this.aprovadoPorId,
  });

  factory TecnologiaProjeto.fromJson(Map<String, dynamic> json) {
    return TecnologiaProjeto(
      tecnologiaId: json['tecnologia_id'],
      projetoId: json['projeto_id'],
      dataAprovacao: json['data_aprovacao'] != null 
          ? DateTime.parse(json['data_aprovacao']) 
          : null,
      aprovadoPorId: json['aprovado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tecnologia_id': tecnologiaId,
      'projeto_id': projetoId,
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'aprovado_por_id': aprovadoPorId,
    };
  }

  TecnologiaProjeto copyWith({
    int? tecnologiaId,
    int? projetoId,
    DateTime? dataAprovacao,
    int? aprovadoPorId,
  }) {
    return TecnologiaProjeto(
      tecnologiaId: tecnologiaId ?? this.tecnologiaId,
      projetoId: projetoId ?? this.projetoId,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      aprovadoPorId: aprovadoPorId ?? this.aprovadoPorId,
    );
  }
}