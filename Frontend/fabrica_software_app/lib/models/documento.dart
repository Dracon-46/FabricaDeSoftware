class Documento {
  final int? id;
  final String? tipo;
  final String? descricao;
  final String arquivoUrl;
  final String nomeDoArquivo;
  final DateTime? dataCriacao;
  final DateTime? dataAprovacao;
  final int projetoId;
  final int? aprovadoPorId;

  Documento({
    this.id,
    this.tipo,
    this.descricao,
    required this.arquivoUrl,
    required this.nomeDoArquivo,
    this.dataCriacao,
    this.dataAprovacao,
    required this.projetoId,
    this.aprovadoPorId,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      tipo: json['tipo'],
      descricao: json['descricao'],
      arquivoUrl: json['arquivo_url'],
      nomeDoArquivo: json['nome_do_arquivo'],
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
      dataAprovacao: json['data_aprovacao'] != null 
          ? DateTime.parse(json['data_aprovacao']) 
          : null,
      projetoId: json['projeto_id'],
      aprovadoPorId: json['aprovado_por_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'descricao': descricao,
      'arquivo_url': arquivoUrl,
      'nome_do_arquivo': nomeDoArquivo,
      'data_criacao': dataCriacao?.toIso8601String(),
      'data_aprovacao': dataAprovacao?.toIso8601String(),
      'projeto_id': projetoId,
      'aprovado_por_id': aprovadoPorId,
    };
  }

  Documento copyWith({
    int? id,
    String? tipo,
    String? descricao,
    String? arquivoUrl,
    String? nomeDoArquivo,
    DateTime? dataCriacao,
    DateTime? dataAprovacao,
    int? projetoId,
    int? aprovadoPorId,
  }) {
    return Documento(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      arquivoUrl: arquivoUrl ?? this.arquivoUrl,
      nomeDoArquivo: nomeDoArquivo ?? this.nomeDoArquivo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAprovacao: dataAprovacao ?? this.dataAprovacao,
      projetoId: projetoId ?? this.projetoId,
      aprovadoPorId: aprovadoPorId ?? this.aprovadoPorId,
    );
  }
}