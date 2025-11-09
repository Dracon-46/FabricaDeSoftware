import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';

// 1. O ENUM (já o tinhas)
enum ClienteModalMode {
  view,
  edit,
  delete,
  create,
}

class ClienteModal extends StatefulWidget {
  final ClienteModalMode mode;
  // 2. Cliente é nulável (opcional)
  final Cliente? cliente; 

  const ClienteModal({
    super.key,
    required this.mode,
    this.cliente, // <-- 'required' removido
  });

  @override
  State<ClienteModal> createState() => _ClienteModalState();
}

class _ClienteModalState extends State<ClienteModal> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cnpjController;
  late TextEditingController _telefoneController;
  late TextEditingController _contatoController;
  late TextEditingController _setorController;
  
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 3. O InitState lida com 'cliente' ser nulo (modo create)
    _nomeController = TextEditingController(text: widget.cliente?.razaoSocial ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
    _cnpjController = TextEditingController(text: widget.cliente?.cnpj ?? '');
    _contatoController = TextEditingController(text: widget.cliente?.contato ?? '');
    _telefoneController = TextEditingController(text: widget.cliente?.telefone ?? '');
    _setorController = TextEditingController(text: widget.cliente?.setor ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cnpjController.dispose();
    _contatoController.dispose();
    _telefoneController.dispose();
    _setorController.dispose();
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
              _buildBody(context),
              const SizedBox(height: 24),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Funções Auxiliares de Build ---

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
      // 4. CORRIGIDO: Adiciona o case 'create'
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
            _buildReadOnlyField("Setor", widget.cliente!.setor ?? 'N/A'),
          ],
        );
      
      // 5. CORRIGIDO: 'create' e 'edit' mostram o mesmo formulário
      case ClienteModalMode.edit:
      case ClienteModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEditableField("Razão Social", _nomeController),
              _buildEditableField("CNPJ", _cnpjController),
              _buildEditableField("E-mail", _emailController),
              _buildEditableField("Setor", _setorController),
              _buildEditableField("Telefone", _telefoneController),
              _buildEditableField("contato", _contatoController),
             
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

    // 6. CORRIGIDO: Lógica unificada para 'create', 'edit', 'delete'
    String actionText;
    Color actionColor;
    VoidCallback? actionCallback;

    switch (widget.mode) {
      case ClienteModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'razao_social': _nomeController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              // (Adiciona os outros campos)
              'endereco_id': widget.cliente!.enderecoId, // Mantém o ID original
            };
            context.read<ClientesProvider>().atualizarCliente(widget.cliente!.id!, data);
            Navigator.pop(context);
          }
        };
        break;
      case ClienteModalMode.delete:
        actionText = 'Excluir';
        actionColor = Colors.red;
        actionCallback = () {
          context.read<ClientesProvider>().excluirCliente(widget.cliente!.id!);
          Navigator.pop(context);
        };
        break;
      case ClienteModalMode.create:
        actionText = 'Criar Cliente';
        actionColor = Colors.green;
        actionCallback = () {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'razao_social': _nomeController.text,
              'cnpj': _cnpjController.text,
              'email': _emailController.text,
              // IMPORTANTE: Adiciona campos obrigatórios
              'endereco_id': 1, // Exemplo!
            };
            context.read<ClientesProvider>().criarCliente(data);
            Navigator.pop(context);
          }
        };
        break;
      case ClienteModalMode.view:
        return const SizedBox.shrink(); // Não deve acontecer
    }

    // Retorna os botões (Cancelar + Ação)
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

  // ... (funções _buildReadOnlyField e _buildEditableField) ...
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

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
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