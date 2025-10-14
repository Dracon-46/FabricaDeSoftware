import '../models/endereco.dart';
import 'base_api_service.dart';

class EnderecosService extends BaseApiService {
  static final EnderecosService instance = EnderecosService._();
  
  EnderecosService._() : super('/enderecos');

  Future<List<Endereco>> listarEnderecos() async {
    return super.getAll((json) => Endereco.fromJson(json));
  }

  Future<Endereco> buscarEndereco(int id) async {
    return super.getById(id, (json) => Endereco.fromJson(json));
  }

  Future<Endereco> criarEndereco(Map<String, dynamic> data) async {
    return super.create(data, (json) => Endereco.fromJson(json));
  }

  Future<Endereco> atualizarEndereco(int id, Map<String, dynamic> data) async {
    return super.update(id, data, (json) => Endereco.fromJson(json));
  }

  Future<void> excluirEndereco(int id) async {
    return super.delete(id);
  }

  // Métodos específicos para endereços
  Future<List<Endereco>> buscarPorCep(String cep) async {
    return super.getAll(
      (json) => Endereco.fromJson(json),
      path: '/cep/$cep'
    );
  }

  Future<List<Endereco>> buscarPorCidade(String cidade) async {
    return super.getAll(
      (json) => Endereco.fromJson(json),
      path: '/cidade/$cidade'
    );
  }

  Future<List<Endereco>> buscarPorEstado(String estado) async {
    return super.getAll(
      (json) => Endereco.fromJson(json),
      path: '/estado/$estado'
    );
  }
}