import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';

// 1. IMPORTA OS NOVOS FICHEIROS (MODELO E MODAL DE ENDEREÇO)
// (Certifica-te que os caminhos estão corretos)
import 'package:fabrica_software_app/models/endereco.dart'; 
import 'package:fabrica_software_app/screens/Clientes/components/Endereco_modal.dart';


enum ClienteModalMode {
  view,
  edit,
  delete,
  create,
}

class ClienteModal extends StatefulWidget {
  final ClienteModalMode mode;
  final Cliente? cliente; 

  const ClienteModal({
    super.key,
    required this.mode,
    this.cliente,
  });

  @override
  State<ClienteModal> createState() => _ClienteModalState();
}

class _ClienteModalState extends State<ClienteModal> {
  late TextEditingController _razaoSocialController;
  late TextEditingController _emailController;
  late TextEditingController _cnpjController;
  late TextEditingController _telefoneController;
  late TextEditingController _contatoController;
  late TextEditingController _setorController;
  // late TextEditingController _enderecoIdController; // <-- REMOVIDO
  
  // 2. ADICIONA UMA VARIÁVEL DE ESTADO PARA O ENDEREÇO ID
  int? _tempEnderecoId;
  
  final _formKey = GlobalKey<FormState>();
  
  // (Opcional) Getter para saber se está a editar
  bool get _isEditing => widget.mode == ClienteModalMode.edit;


  @override
  void initState() {
    super.initState();
    _razaoSocialController = TextEditingController(text: widget.cliente?.razaoSocial ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
    _cnpjController = TextEditingController(text: widget.cliente?.cnpj ?? '');
    _telefoneController = TextEditingController(text: widget.cliente?.telefone ?? '');
    _contatoController = TextEditingController(text: widget.cliente?.contato ?? '');
    _setorController = TextEditingController(text: widget.cliente?.setor ?? '');
    
    // 3. INICIALIZA A VARIÁVEL DE ESTADO DO ENDEREÇO
    _tempEnderecoId = widget.cliente?.enderecoId;
  }

  @override
  void dispose() {
    _razaoSocialController.dispose();
    _emailController.dispose();
    _cnpjController.dispose();
    _telefoneController.dispose();
    _contatoController.dispose();
    _setorController.dispose();
    // _enderecoIdController.dispose(); // <-- REMOVIDO
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const Divider(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildBody(context),
                ),
              ),
              const SizedBox(height: 24),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String title;
    IconData icon;
    Color iconColor;

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
      case ClienteModalMode.create:
        title = 'Criar Novo Cliente';
        icon = FontAwesomeIcons.plus;
        iconColor = Colors.green;
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
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (widget.mode) {
      case ClienteModalMode.view:
        return Column(
          children: [
            _buildReadOnlyField("Razão Social", widget.cliente!.razaoSocial),
            _buildReadOnlyField("CNPJ", widget.cliente!.cnpj),
            _buildReadOnlyField("E-mail", widget.cliente!.email),
            _buildReadOnlyField("Telefone", widget.cliente!.telefone ?? 'N/A'),
            _buildReadOnlyField("Setor", widget.cliente!.setor ?? 'N/A'),
            _buildReadOnlyField("Contato", widget.cliente!.contato ?? 'N/A'),
            
            // 4. SUBSTITUI o TextField de ID por um Botão
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.location_on_outlined),
              label: Text("Ver Endereço"),
              onPressed: () {
                _abrirModalEndereco(context);
              },
            )
          ],
        );
      
      case ClienteModalMode.edit:
      case ClienteModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField("Razão Social *", _razaoSocialController),
              _buildEditableField("CNPJ *", _cnpjController),
              _buildEditableField("E-mail *", _emailController),
              _buildEditableField("Telefone", _telefoneController, isRequired: false),
              _buildEditableField("Setor", _setorController, isRequired: false),
              _buildEditableField("Contato", _contatoController, isRequired: false),
              
              // 5. SUBSTITUI o TextField de ID por um Botão
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.edit_location_outlined),
                label: Text(
                  _tempEnderecoId != null
                      ? "Editar Endereço"
                      : "Adicionar Endereço"
                ),
                onPressed: () {
                  _abrirModalEndereco(context);
                },
              ),
            ],
          ),
        );
      
      case ClienteModalMode.delete:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              const TextSpan(text: 'Você tem certeza que deseja excluir o cliente '),
              TextSpan(
                text: widget.cliente!.razaoSocial,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nEsta ação não pode ser desfeita.'),
            ],
          ),
        );
    }
  }

  // --- 6. ADICIONA A FUNÇÃO PARA ABRIR O MODAL FILHO ---
  void _abrirModalEndereco(BuildContext context) async {
    
    // Converte o modo do Pai (Cliente) para o modo do Filho (Endereço)
    EnderecoModalMode modoFilho;
    
    switch (widget.mode) {
      case ClienteModalMode.view:
        modoFilho = EnderecoModalMode.view;
        break;
      case ClienteModalMode.edit:
        // Se já temos um ID, editamos. Se não, criamos.
        modoFilho = (_tempEnderecoId == null) ? EnderecoModalMode.create : EnderecoModalMode.edit;
        break;
      case ClienteModalMode.create:
        // Se estamos a criar um cliente, também estamos a criar um endereço
        modoFilho = EnderecoModalMode.create;
        break;
      default:
        return; // Não abre o modal de endereço se estiver a apagar
    }

    // TODO: Buscar o 'Endereco' real do provider usando _tempEnderecoId
    // Por agora, vamos simular (como na tua sugestão)
    Endereco? enderecoAtual = (_tempEnderecoId != null)
      ? Endereco(
          id: _tempEnderecoId,
          logradouro: "Rua Fictícia (Buscada)",
          cep: "12345-678",
          cidade: "Cidade Fictícia",
          estado: "SP",
          pais: "Brasil"
        )
      : null;

    // Chama o Modal Filho (Pilha de Diálogos) e ESPERA (await) pelo resultado (o ID)
    final novoEnderecoId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EnderecoModal(
        mode: modoFilho,
        endereco: enderecoAtual,
      ),
    );

    // 7. ATUALIZA O ESTADO quando o modal filho fechar
    if (novoEnderecoId != null) {
      setState(() {
        _tempEnderecoId = novoEnderecoId;
      });
    }
  }


  Widget _buildFooter(BuildContext context) {
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

    String actionText;
    Color actionColor;
    VoidCallback? actionCallback;

    switch (widget.mode) {
      case ClienteModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () async {
          // 8. VALIDA se o ID do endereço foi preenchido
          if (_tempEnderecoId == null) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Erro: Endereço é obrigatório.'), 
                backgroundColor: Colors.red));
             return;
          }
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'razao_social': _razaoSocialController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              'telefone': _telefoneController.text.isEmpty ? null : _telefoneController.text,
              'setor': _setorController.text.isEmpty ? null : _setorController.text,
              'contato': _contatoController.text.isEmpty ? null : _contatoController.text,
              'endereco_id': _tempEnderecoId, // <-- USA A VARIÁVEL DE ESTADO
            };
            await context.read<ClientesProvider>().atualizarCliente(widget.cliente!.id!, data);
            Navigator.pop(context);
          }
        };
        break;
      case ClienteModalMode.delete:
        actionText = 'Excluir';
        actionColor = Colors.red;
        actionCallback = () async {
          await context.read<ClientesProvider>().excluirCliente(widget.cliente!.id!);
          Navigator.pop(context);
        };
        break;
      case ClienteModalMode.create:
        actionText = 'Criar Cliente';
        actionColor = Colors.green;
        actionCallback = () async {
          // 8. VALIDA se o ID do endereço foi preenchido
          if (_tempEnderecoId == null) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Erro: Endereço é obrigatório.'), 
                backgroundColor: Colors.red));
             return;
          }
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'razao_social': _razaoSocialController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              'telefone': _telefoneController.text.isEmpty ? null : _telefoneController.text,
              'setor': _setorController.text.isEmpty ? null : _setorController.text,
              'contato': _contatoController.text.isEmpty ? null : _contatoController.text,
              'endereco_id': _tempEnderecoId, // <-- USA A VARIÁVEL DE ESTADO
            };
            await context.read<ClientesProvider>().criarCliente(data);
            Navigator.pop(context);
          }
        };
        break;
      case ClienteModalMode.view:
        return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: actionCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
          ),
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {bool isRequired = true, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Este campo é obrigatório';
          }
          if (isNumeric && value != null && value.isNotEmpty && int.tryParse(value) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
      ),
    );
  }
}