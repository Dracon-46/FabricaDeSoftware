import 'enums.dart';

class Projeto {
  final int? id;
  final String nomeProjeto;
  final String? descricao;
  final String? modeloProjeto;
  final String? metodologia;
  final String? escopo;
  final DateTime? dataInicio;
  final DateTime? dataFinalPrevisto;
  final DateTime? dataFinal;
  final ComplexidadeProjeto? complexidade;
  final double? orcamentoEstimado;
  final DateTime? dataCriacao;
  final int clienteId;
  final int? responsavelId;
  final int criadoPorId;

  Projeto({
    this.id,
    required this.nomeProjeto,
    this.descricao,
    this.modeloProjeto,
    this.metodologia,
    this.escopo,
    this.dataInicio,
    this.dataFinalPrevisto,
    this.dataFinal,
    this.complexidade,
    this.orcamentoEstimado,
    this.dataCriacao,
    required this.clienteId,
    this.responsavelId,
    required this.criadoPorId,
  });

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      id: json['id'],
      nomeProjeto: json['nome_projeto'],
      descricao: json['descricao'],
      modeloProjeto: json['modelo_projeto'],
      metodologia: json['metodologia'],
      escopo: json['escopo'],
      dataInicio: json['data_inicio'] != null 
          ? DateTime.parse(json['data_inicio']) 
          : null,
      dataFinalPrevisto: json['data_final_previsto'] != null 
          ? DateTime.parse(json['data_final_previsto']) 
          : null,
      dataFinal: json['data_final'] != null 
          ? DateTime.parse(json['data_final']) 
          : null,
      complexidade: json['complexidade'] != null 
          ? ComplexidadeProjeto.fromString(json['complexidade'])
          : null,
      orcamentoEstimado: json['orcamento_estimado'] != null 
          ? double.parse(json['orcamento_estimado'].toString())
          : null,
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
      clienteId: json['cliente_id'],
      responsavelId: json['responsavel_id'],
      criadoPorId: json['criado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_projeto': nomeProjeto,
      'descricao': descricao,
      'modelo_projeto': modeloProjeto,
      'metodologia': metodologia,
      'escopo': escopo,
      'data_inicio': dataInicio?.toIso8601String(),
      'data_final_previsto': dataFinalPrevisto?.toIso8601String(),
      'data_final': dataFinal?.toIso8601String(),
      'complexidade': complexidade?.toString().split('.').last,
      'orcamento_estimado': orcamentoEstimado,
      'data_criacao': dataCriacao?.toIso8601String(),
      'cliente_id': clienteId,
      'responsavel_id': responsavelId,
      'criado_por_id': criadoPorId,
    };
  }

  Projeto copyWith({
    int? id,
    String? nomeProjeto,
    String? descricao,
    String? modeloProjeto,
    String? metodologia,
    String? escopo,
    DateTime? dataInicio,
    DateTime? dataFinalPrevisto,
    DateTime? dataFinal,
    ComplexidadeProjeto? complexidade,
    double? orcamentoEstimado,
    DateTime? dataCriacao,
    int? clienteId,
    int? responsavelId,
    int? criadoPorId,
  }) {
    return Projeto(
      id: id ?? this.id,
      nomeProjeto: nomeProjeto ?? this.nomeProjeto,
      descricao: descricao ?? this.descricao,
      modeloProjeto: modeloProjeto ?? this.modeloProjeto,
      metodologia: metodologia ?? this.metodologia,
      escopo: escopo ?? this.escopo,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFinalPrevisto: dataFinalPrevisto ?? this.dataFinalPrevisto,
      dataFinal: dataFinal ?? this.dataFinal,
      complexidade: complexidade ?? this.complexidade,
      orcamentoEstimado: orcamentoEstimado ?? this.orcamentoEstimado,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      clienteId: clienteId ?? this.clienteId,
      responsavelId: responsavelId ?? this.responsavelId,
      criadoPorId: criadoPorId ?? this.criadoPorId,
    );
  }
}