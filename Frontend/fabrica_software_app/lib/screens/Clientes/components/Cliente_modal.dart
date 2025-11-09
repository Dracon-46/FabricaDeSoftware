import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';

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
  // 1. Controladores para TODOS os campos do teu modelo
  late TextEditingController _razaoSocialController;
  late TextEditingController _emailController;
  late TextEditingController _cnpjController;
  late TextEditingController _telefoneController;
  late TextEditingController _contatoController;
  late TextEditingController _setorController;
  late TextEditingController _enderecoIdController;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 2. Inicializa TODOS os controladores
    _razaoSocialController = TextEditingController(text: widget.cliente?.razaoSocial ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
    _cnpjController = TextEditingController(text: widget.cliente?.cnpj ?? '');
    _telefoneController = TextEditingController(text: widget.cliente?.telefone ?? '');
    _contatoController = TextEditingController(text: widget.cliente?.contato ?? '');
    _setorController = TextEditingController(text: widget.cliente?.setor ?? '');
    _enderecoIdController = TextEditingController(text: widget.cliente?.enderecoId.toString() ?? '');
  }

  @override
  void dispose() {
    // 3. Limpa TODOS os controladores
    _razaoSocialController.dispose();
    _emailController.dispose();
    _cnpjController.dispose();
    _telefoneController.dispose();
    _contatoController.dispose();
    _setorController.dispose();
    _enderecoIdController.dispose();
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
              // 4. Adiciona Flexible + SingleChildScrollView
              //    (Impede o modal de "estourar" com o teclado)
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
          // 5. Mostra TODOS os campos
          children: [
            _buildReadOnlyField("Razão Social", widget.cliente!.razaoSocial),
            _buildReadOnlyField("CNPJ", widget.cliente!.cnpj),
            _buildReadOnlyField("E-mail", widget.cliente!.email),
            _buildReadOnlyField("Telefone", widget.cliente!.telefone ?? 'N/A'),
            _buildReadOnlyField("Setor", widget.cliente!.setor ?? 'N/A'),
            _buildReadOnlyField("Contato", widget.cliente!.contato ?? 'N/A'),
            _buildReadOnlyField("Endereço ID", widget.cliente!.enderecoId.toString()),
          ],
        );
      
      case ClienteModalMode.edit:
      case ClienteModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 6. Mostra TODOS os campos para edição
              _buildEditableField("Razão Social *", _razaoSocialController),
              _buildEditableField("CNPJ *", _cnpjController),
              _buildEditableField("E-mail *", _emailController),
              _buildEditableField("Telefone", _telefoneController, isRequired: false),
              _buildEditableField("Setor", _setorController, isRequired: false),
              _buildEditableField("Contato", _contatoController, isRequired: false),
              _buildEditableField("ID do Endereço *", _enderecoIdController, isNumeric: true),
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
          if (_formKey.currentState?.validate() ?? false) {
            // 7. Envia TODOS os dados
            final data = {
              'razao_social': _razaoSocialController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              'telefone': _telefoneController.text.isEmpty ? null : _telefoneController.text,
              'setor': _setorController.text.isEmpty ? null : _setorController.text,
              'contato': _contatoController.text.isEmpty ? null : _contatoController.text,
              'endereco_id': int.parse(_enderecoIdController.text),
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
          if (_formKey.currentState?.validate() ?? false) {
            // 7. Envia TODOS os dados
            final data = {
              'razao_social': _razaoSocialController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              'telefone': _telefoneController.text.isEmpty ? null : _telefoneController.text,
              'setor': _setorController.text.isEmpty ? null : _setorController.text,
              'contato': _contatoController.text.isEmpty ? null : _contatoController.text,
              'endereco_id': int.parse(_enderecoIdController.text),
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

  // 8. ATUALIZADO: _buildEditableField com validação extra
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