enum NivelUsuario {
  admin,
  gerente,
  colaborador;

  static NivelUsuario fromString(String value) {
    return NivelUsuario.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => NivelUsuario.colaborador,
    );
  }
}

enum ComplexidadeProjeto {
  baixa,
  media,
  alta;

  static ComplexidadeProjeto fromString(String value) {
    return ComplexidadeProjeto.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ComplexidadeProjeto.media,
    );
  }
}

enum PrioridadeRequisito {
  baixa,
  media,
  alta,
  critica;

  static PrioridadeRequisito fromString(String value) {
    return PrioridadeRequisito.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => PrioridadeRequisito.media,
    );
  }
}