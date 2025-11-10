import 'package:fabrica_software_app/providers/endereco_provider.dart';
import 'package:fabrica_software_app/screens/Clientes/components/Endereco_modal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/clientes_provider.dart';
import 'package:fabrica_software_app/models/endereco.dart';



enum ClienteModalMode {
  view,
  edit,
  delete,
  create,
}

class ClienteModal extends StatefulWidget {
  final ClienteModalMode mode;
  final Cliente? cliente; 
  // 2. ADICIONA O PROVIDER COMO PARÂMETRO OBRIGATÓRIO
  final EnderecosProvider enderecosProvider;

  const ClienteModal({
    super.key,
    required this.mode,
    required this.enderecosProvider, // 3. ADICIONA AO CONSTRUTOR
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
  
  int? _tempEnderecoId;
  
  final _formKey = GlobalKey<FormState>();
  
  bool _isClienteModalLoading = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = context.watch<ClientesProvider>();
    if (clientesProvider.isLoading && _isClienteModalLoading) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Salvando Cliente...'),
            ],
          ),
        ),
      );
    }
    
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
                  child: _isClienteModalLoading 
                      ? const Center(child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ))
                      : _buildBody(context),
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
            
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Ver Endereço"),
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

  // 4. FUNÇÃO ATUALIZADA
  void _abrirModalEndereco(BuildContext context) async {
    
    EnderecoModalMode modoFilho;
    
    switch (widget.mode) {
      case ClienteModalMode.view:
        modoFilho = EnderecoModalMode.view;
        break;
      case ClienteModalMode.edit:
        modoFilho = (_tempEnderecoId == null) ? EnderecoModalMode.create : EnderecoModalMode.edit;
        break;
      case ClienteModalMode.create:
        modoFilho = EnderecoModalMode.create;
        break;
      default:
        return; 
    }

    Endereco? enderecoAtual;
    if (_tempEnderecoId != null) {
      setState(() { _isClienteModalLoading = true; });
      try {
        // 5. USA O PROVIDER DO 'widget' EM VEZ DE context.read
        enderecoAtual = await widget.enderecosProvider.buscarEndereco(_tempEnderecoId!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao buscar endereço: $e'),
          backgroundColor: Colors.red,
        ));
        setState(() { _isClienteModalLoading = false; });
        return; 
      }
      setState(() { _isClienteModalLoading = false; });
    }

    final novoEnderecoId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false, // Mantém isto
      builder: (ctx) => EnderecoModal(
        mode: modoFilho,
        endereco: enderecoAtual,
        enderecosProvider: widget.enderecosProvider, 
      ),
    );

    if (novoEnderecoId != null) {
      setState(() {
        _tempEnderecoId = novoEnderecoId;
      });
    }
  }

  Future<void> _submitClienteForm(VoidCallback onSuccess) async {
    if (_tempEnderecoId == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro: Endereço é obrigatório.'), 
          backgroundColor: Colors.red));
       return;
    }
    
    if (_formKey.currentState?.validate() ?? false) {
      setState(() { _isClienteModalLoading = true; });
      
      final data = {
        'razao_social': _razaoSocialController.text,
        'cnpj': _cnpjController.text,
        'email': _emailController.text,
        'telefone': _telefoneController.text.isEmpty ? null : _telefoneController.text,
        'setor': _setorController.text.isEmpty ? null : _setorController.text,
        'contato': _contatoController.text.isEmpty ? null : _contatoController.text,
        'endereco_id': _tempEnderecoId,
      };

      try {
        if (widget.mode == ClienteModalMode.edit) {
          await context.read<ClientesProvider>().atualizarCliente(widget.cliente!.id!, data);
        } else {
          await context.read<ClientesProvider>().criarCliente(data);
        }
        onSuccess(); 
      } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erro ao salvar cliente: $e'), 
            backgroundColor: Colors.red));
      } finally {
         setState(() { _isClienteModalLoading = false; });
      }
    }
  }
  
  Future<void> _deleteCliente(VoidCallback onSuccess) async {
    setState(() { _isClienteModalLoading = true; });
    try {
      await context.read<ClientesProvider>().excluirCliente(widget.cliente!.id!);
      onSuccess();
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erro ao excluir cliente: $e'), 
            backgroundColor: Colors.red));
    } finally {
      setState(() { _isClienteModalLoading = false; });
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

    final onSuccess = () => Navigator.pop(context);

    switch (widget.mode) {
      case ClienteModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () => _submitClienteForm(onSuccess);
        break;
      case ClienteModalMode.delete:
        actionText = 'Excluir';
        actionColor = Colors.red;
        actionCallback = () => _deleteCliente(onSuccess);
        break;
      case ClienteModalMode.create:
        actionText = 'Criar Cliente';
        actionColor = Colors.green;
        actionCallback = () => _submitClienteForm(onSuccess);
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
          onPressed: _isClienteModalLoading ? null : actionCallback,
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