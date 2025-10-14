import 'enums.dart';

class RequisitoProjeto {
  final int requisitoId;
  final int projetoId;
  final String? codigoRequisito;
  final PrioridadeRequisito? prioridade;
  final DateTime? dataAprovacao;
  final int? aprovadoPorId;
  final int? criadoPorId;

  RequisitoProjeto({
    required this.requisitoId,
    required this.projetoId,
    this.codigoRequisito,
    this.prioridade,
    this.dataAprovacao,
    this.aprovadoPorId,
    this.criadoPorId,
  });

  factory RequisitoProjeto.fromJson(Map<String, dynamic> json) {
    return RequisitoProjeto(
      requisitoId: json['requisito_id'],
      projetoId: json['projeto_id'],
      codigoRequisito: json['codigo_requisito'],
      prioridade: json['prioridade'] != null 
          ? PrioridadeRequisito.fromString(json['prioridade'])
          : null,
      dataAprovacao: json['data_aprovacao'] != null 
          ? DateTime.parse(json['data_aprovacao']) 
          : null,
      aprovadoPorId: json['aprovado_por_id'],
      criadoPorId: json['criado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requisito_id': requisitoId,
      'projeto_id': projetoId,
      'codigo_requisito': codigoRequisito,
      'prioridade': prioridade?.toString().split('.').last,
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'aprovado_por_id': aprovadoPorId,
      'criado_por_id': criadoPorId,
    };
  }

  RequisitoProjeto copyWith({
    int? requisitoId,
    int? projetoId,
    String? codigoRequisito,
    PrioridadeRequisito? prioridade,
    DateTime? dataAprovacao,
    int? aprovadoPorId,
    int? criadoPorId,
  }) {
    return RequisitoProjeto(
      requisitoId: requisitoId ?? this.requisitoId,
      projetoId: projetoId ?? this.projetoId,
      codigoRequisito: codigoRequisito ?? this.codigoRequisito,
      prioridade: prioridade ?? this.prioridade,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      aprovadoPorId: aprovadoPorId ?? this.aprovadoPorId,
      criadoPorId: criadoPorId ?? this.criadoPorId,
    );
  }
}