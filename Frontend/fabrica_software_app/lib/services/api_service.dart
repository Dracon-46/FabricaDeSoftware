import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Necessário para pegar o token
import 'package:fabrica_software_app/services/api_config.dart';

class ApiService {
  
  // --- GERENCIAMENTO DE TOKEN (NOVO) ---

  // Salva o token no dispositivo (Chame isso no seu Login!)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print("TOKEN SALVO: $token"); // Debug
  }

  // Remove o token (Chame isso no Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Pega o cabeçalho com o token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    
    print("TOKEN RECUPERADO DO STORAGE: $token"); // Debug essencial

    if (token == null) {
      print("ERRO: Tentando fazer requisição sem token salvo.");
    }

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- HELPERS ---
  
  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // --- REQUISIÇÕES DE IA (COM AUTH) ---

  static Future<List<dynamic>> gerarRequisitosBackend(String escopo, String nomeProjeto) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/ai/gerar-requisitos');
    final headers = await _getHeaders();

    // Verificação de segurança antes de chamar
    if (!headers.containsKey('Authorization')) {
      throw Exception('Usuário não autenticado. Faça login novamente.');
    }

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({
          "escopo": escopo, 
          "nomeProjeto": nomeProjeto
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Erro na IA (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Falha de conexão com IA: $e');
    }
  }

  static Future<double> estimarOrcamentoBackend(Map<String, dynamic> dadosProjeto) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/ai/estimar-orcamento');
    final headers = await _getHeaders();
    
    if (!headers.containsKey('Authorization')) {
      throw Exception('Usuário não autenticado. Faça login novamente.');
    }

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(dadosProjeto),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['orcamento_estimado'] as num).toDouble();
      } else {
        throw Exception('Erro na IA de Orçamento (${response.statusCode})');
      }
    } catch (e) {
      print("Erro IA Orçamento: $e");
      return 0.0;
    }
  }

  // --- CRUD PROJETO ---

  static Future<void> criarProjetoCompleto(Map<String, dynamic> dtoData) async {
    final headers = await _getHeaders();

    // 1. Criar Projeto
    final uriProjeto = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.projetos}');
    
    final projetoPayload = {
      "nome_projeto": dtoData['nome_projeto'],
      "descricao": dtoData['descricao'],
      "cliente_id": dtoData['cliente_id'],
      "metodologia": dtoData['metodologia'],
      "orcamento_estimado": dtoData['orcamento_estimado'],
      "data_inicio": dtoData['data_inicio'],
      "data_final_previsto": dtoData['data_final_previsto'],
      "criado_por_id": 1, 
      "responsavel_id": 1 
    };

    final respProj = await http.post(uriProjeto, headers: headers, body: jsonEncode(projetoPayload));

    if (respProj.statusCode != 201 && respProj.statusCode != 200) {
      throw Exception('Falha ao criar projeto: ${respProj.body}');
    }

    final projetoCriado = jsonDecode(respProj.body);
    final int projetoId = _parseId(projetoCriado['id']);
    print("Projeto $projetoId criado com sucesso.");

    // 2. Vínculos (Usam o mesmo header)
    
    // Tecnologias
    for (var techId in (dtoData['tecnologias'] as List)) {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tecnologiasProjeto}'),
        headers: headers,
        body: jsonEncode({
          "projeto_id": projetoId,
          "tecnologia_id": _parseId(techId),
          "data_aprovacao": DateTime.now().toIso8601String(),
          "aprovado_por_id": 1
        })
      );
    }

    // Equipe
    for (var membro in (dtoData['equipe'] as List)) {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.contribuidoresProjeto}'),
        headers: headers,
        body: jsonEncode({
          "projeto_id": projetoId,
          "contribuidor_id": _parseId(membro['id']),
          "data_inicio": dtoData['data_inicio'],
        })
      );
    }

    // Recursos
    for (var recId in (dtoData['recursos'] as List)) {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.recursosProjeto}'),
        headers: headers,
        body: jsonEncode({
          "projeto_id": projetoId,
          "recurso_id": _parseId(recId),
          "custo_hora": 0.0,
          "data_alocacao": dtoData['data_inicio']
        })
      );
    }

    // Requisitos
    for (var req in (dtoData['requisitos'] as List)) {
      final respReq = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.requisitos}'), 
        headers: headers,
        body: jsonEncode({
          "tipo": req['tipo'],
          "descricao": "${req['titulo']}: ${req['descricao']}",
          "observacoes": "Via App"
        })
      );

      if (respReq.statusCode == 200 || respReq.statusCode == 201) {
        final reqCriado = jsonDecode(respReq.body);
        final reqId = _parseId(reqCriado['id']);

        await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.requisitosProjeto}'),
          headers: headers,
          body: jsonEncode({
            "projeto_id": projetoId,
            "requisito_id": reqId,
            "prioridade": req['prioridade'].toString().toLowerCase(),
            "codigo_requisito": "REQ-${DateTime.now().millisecondsSinceEpoch}",
            "criado_por_id": 1
          })
        );
      }
    }
  }

  // --- GETTERS ---
  static Future<List<dynamic>> getClientes() async => _get(ApiConfig.clientes);
  static Future<List<dynamic>> getTecnologias() async => _get(ApiConfig.tecnologias);
  static Future<List<dynamic>> getContribuidores() async => _get(ApiConfig.contribuidores);
  static Future<List<dynamic>> getRecursos() async => _get(ApiConfig.recursos);

  static Future<List<dynamic>> _get(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }
}