import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Importe seu modelo Cliente (você já o tem)
import 'package:fabrica_software_app/models/cliente.dart';
// Importe seu Provider para as ações
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';

// 1. O ENUM (O "Modo")
//    Define as "ações" que o modal pode executar.
enum ClienteModalMode {
  view,
  edit,
  delete,
}

// 2. O WIDGET (Stateful)
class ClienteModal extends StatefulWidget {
  final ClienteModalMode mode; // O modo (Ver, Editar, Apagar)
  final Cliente cliente;      // O cliente específico
  // (Você não precisa do 'id', passe o objeto 'cliente' inteiro.
  //  Assim, você já tem os dados para "Ver" e "Editar")

  const ClienteModal({
    super.key,
    required this.mode,
    required this.cliente,
  });

  @override
  State<ClienteModal> createState() => _ClienteModalState();
}

class _ClienteModalState extends State<ClienteModal> {
  // 3. O "Cérebro" do Modal
  //    Controladores para o modo "Editar"
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cnpjController;
  
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 4. INICIALIZAÇÃO
    //    Preenche os controladores com os dados do cliente
    //    que veio pelo construtor (widget.cliente).
    _nomeController = TextEditingController(text: widget.cliente.razaoSocial);
    _emailController = TextEditingController(text: widget.cliente.email);
    _cnpjController = TextEditingController(text: widget.cliente.cnpj);
  }

  @override
  void dispose() {
    // 5. LIMPEZA
    _nomeController.dispose();
    _emailController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  // --- O Build Principal (O "Molde") ---
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600), // Limita a largura
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Encolhe para o tamanho do conteúdo
            children: [
              
              // 1. CABEÇALHO (Muda baseado no 'widget.mode')
              _buildHeader(context),
              const Divider(height: 24),

              // 2. CORPO / "PEITO" (Muda baseado no 'widget.mode')
              _buildBody(context),
              const SizedBox(height: 24),

              // 3. RODAPÉ (Muda baseado no 'widget.mode')
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Funções Auxiliares de Build ---

  // Constrói o Cabeçalho
  Widget _buildHeader(BuildContext context) {
    String title;
    IconData icon;
    Color iconColor;

    // Lógica para mudar o cabeçalho
    switch (widget.mode) {
      case ClienteModalMode.view:
        title = 'Detalhes do Cliente';
        icon = FontAwesomeIcons.solidEye;
        iconColor = Theme.of(context).primaryColor;
        break;
      case ClienteModalMode.edit:
        title = 'Editar Cliente';
        icon = FontAwesomeIcons.solidPenToSquare;
        iconColor = Colors.orange;
        break;
      case ClienteModalMode.delete:
        title = 'Excluir Cliente';
        icon = FontAwesomeIcons.trash;
        iconColor = Colors.red;
        break;
    }

    return Row(
      children: [
        FaIcon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), // Botão de fechar
        ),
      ],
    );
  }

  // Constrói o Corpo (Formulário ou Mensagem)
  Widget _buildBody(BuildContext context) {
    // Lógica para mudar o "peito"
    switch (widget.mode) {
      
      // --- MODO VISUALIZAR ---
      case ClienteModalMode.view:
        return Column(
          children: [
            _buildReadOnlyField("Razão Social", widget.cliente.razaoSocial),
            _buildReadOnlyField("CNPJ", widget.cliente.cnpj),
            _buildReadOnlyField("E-mail", widget.cliente.email),
            _buildReadOnlyField("Setor", widget.cliente.setor ?? 'N/A'),
          ],
        );
      
      // --- MODO EDITAR ---
      case ClienteModalMode.edit:
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEditableField("Razão Social", _nomeController),
              _buildEditableField("CNPJ", _cnpjController),
              _buildEditableField("E-mail", _emailController),
              // (Adicione um _buildEditableField para o 'setor' se necessário)
            ],
          ),
        );
      
      // --- MODO APAGAR ---
      case ClienteModalMode.delete:
        return RichText( // Widget para textos com estilos misturados
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              const TextSpan(text: 'Você tem certeza que deseja excluir o cliente '),
              TextSpan(
                text: widget.cliente.razaoSocial, // Usa o nome
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nEsta ação não pode ser desfeita.'),
            ],
          ),
        );
    }
  }

  // Constrói o Rodapé (Botões)
  Widget _buildFooter(BuildContext context) {
    // Lógica para mudar os botões
    
    // Se for 'view', só tem botão de Fechar
    if (widget.mode == ClienteModalMode.view) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      );
    }

    // Se for 'edit' ou 'delete', tem Cancelar + Ação
    String actionText = (widget.mode == ClienteModalMode.edit) ? 'Salvar' : 'Excluir';
    Color actionColor = (widget.mode == ClienteModalMode.edit) ? Theme.of(context).primaryColor : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // AQUI VOCÊ CHAMA O PROVIDER
            if (widget.mode == ClienteModalMode.edit) {
              // (Opcional: validar o formulário)
              // if (_formKey.currentState!.validate()) {
                print('Salvando...');
                // TODO: Chamar o provider de ATUALIZAR
                // Map<String, dynamic> data = {
                //   'razao_social': _nomeController.text,
                //   'cnpj': _cnpjController.text,
                //   'email': _emailController.text,
                // };
                // context.read<ClientesProvider>().atualizarCliente(widget.cliente.id!, data);
              // }
            } else {
              print('Excluindo...');
              // Chama o provider de EXCLUIR
              context.read<ClientesProvider>().excluirCliente(widget.cliente.id!);
            }
            Navigator.pop(context); // Fecha o modal
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
          ),
          child: Text(actionText),
        ),
      ],
    );
  }

  // --- Widgets Auxiliares para os Campos ---

  // Campo de texto para MODO VISUALIZAR
  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true, // "Apenas Leitura"
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Campo de texto para MODO EDITAR
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        // Adiciona validação
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          return null;
        },
      ),
    );
  }
}