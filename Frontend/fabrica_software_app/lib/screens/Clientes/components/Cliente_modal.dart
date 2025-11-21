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
  final EnderecosProvider enderecosProvider;

  const ClienteModal({
    super.key,
    required this.mode,
    required this.enderecosProvider,
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

  // --- VARIÁVEIS DE ESTILO CENTRALIZADAS ---
  
  // 1. Estilo da caixa do Input (Sombra e Fundo)
  final BoxDecoration _inputBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08), // Sombra suave
        blurRadius: 5, // Desfoque maior
        spreadRadius: 1, // Espalha um pouco
        offset: const Offset(0, 4), // Deslocamento para baixo
      ),
    ],
    border: Border.all(color: const Color.fromARGB(255, 216, 211, 211)), // Borda quase invisível
  );

  // 2. Estilo do Botão Azul (Usado no Ver e no Editar)
  final ButtonStyle _blueButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF2962FF), // Texto Azul
    side: const BorderSide(color: Color(0xFF2962FF), width: 1.5), // Borda Azul
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  );

  @override
  void initState() {
    super.initState();
    // Aqui usamos ?. e ??, então não dá erro se cliente for null
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
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const Divider(height: 30, thickness: 0.5, color: Colors.grey),
              Flexible(
                child: SingleChildScrollView(
                  child: _isClienteModalLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
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
    Color bgColorIcon;

    switch (widget.mode) {
      case ClienteModalMode.view:
        title = 'Detalhes do Cliente';
        icon = FontAwesomeIcons.solidEye;
        iconColor = const Color(0xFF2962FF);
        bgColorIcon = const Color(0xFFE3F2FD);
        break;
      case ClienteModalMode.edit:
        title = 'Editar Cliente';
        icon = FontAwesomeIcons.solidPenToSquare;
        iconColor = Colors.orange;
        bgColorIcon = Colors.orange.shade50;
        break;
      case ClienteModalMode.delete:
        title = 'Excluir Cliente';
        icon = FontAwesomeIcons.trash;
        iconColor = Colors.red;
        bgColorIcon = Colors.red.shade50;
        break;
      case ClienteModalMode.create:
        title = 'Criar Novo Cliente';
        icon = FontAwesomeIcons.plus;
        iconColor = Colors.green;
        bgColorIcon = Colors.green.shade50;
        break;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColorIcon,
            shape: BoxShape.circle,
          ),
          child: FaIcon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w500,
              color: Colors.black87
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    // Lista de campos comuns para reutilizar
    final commonFields = [
      _buildLabelAndField("Razão Social *", controller: _razaoSocialController),
      _buildLabelAndField("CNPJ *", controller: _cnpjController),
      _buildLabelAndField("E-mail *", controller: _emailController),
      _buildLabelAndField("Telefone", controller: _telefoneController, isRequired: false),
      _buildLabelAndField("Setor", controller: _setorController, isRequired: false),
      _buildLabelAndField("Contato", controller: _contatoController, isRequired: false),
    ];
    
    // CORREÇÃO: Removemos a definição de viewFields daqui.
    // Ela estava tentando acessar widget.cliente!.algo e dava crash no CREATE (onde cliente é null).

    switch (widget.mode) {
      case ClienteModalMode.view:
        // CORREÇÃO: Definimos viewFields APENAS aqui dentro
        final viewFields = [
          _buildLabelAndField("Razão Social", textValue: widget.cliente!.razaoSocial),
          _buildLabelAndField("CNPJ", textValue: widget.cliente!.cnpj),
          _buildLabelAndField("E-mail", textValue: widget.cliente!.email),
          _buildLabelAndField("Telefone", textValue: widget.cliente!.telefone ?? ''),
          _buildLabelAndField("Setor", textValue: widget.cliente!.setor ?? ''),
          _buildLabelAndField("Contato", textValue: widget.cliente!.contato ?? ''),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...viewFields,
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.location_on_outlined, size: 18),
                label: const Text("Ver Endereço"),
                style: _blueButtonStyle, // Usando estilo centralizado
                onPressed: () => _abrirModalEndereco(context),
              ),
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
              ...commonFields,
              const SizedBox(height: 24),
              
              // Botão Edit/Add Endereço com o MESMO estilo do Ver
              OutlinedButton.icon(
                icon: const Icon(Icons.edit_location_outlined, size: 18),
                label: Text(
                  _tempEnderecoId != null ? "Editar Endereço" : "Adicionar Endereço"
                ),
                style: _blueButtonStyle, // AQUI: Estilo igual ao de cima
                onPressed: () => _abrirModalEndereco(context),
              ),
            ],
          ),
        );

      case ClienteModalMode.delete:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              children: [
                const TextSpan(text: 'Você tem certeza que deseja excluir o cliente \n'),
                TextSpan(
                  text: widget.cliente!.razaoSocial,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const TextSpan(text: '\n\nEsta ação não pode ser desfeita.'),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildLabelAndField(String label, {String? textValue, TextEditingController? controller, bool isRequired = true}) {
    bool isReadOnly = widget.mode == ClienteModalMode.view;
    final textController = controller ?? TextEditingController(text: textValue);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          
          // CONTAINER PARA A SOMBRA (O Input fica dentro dele)
          Container(
            decoration: _inputBoxDecoration, // Estilo centralizado aqui
            child: TextFormField(
              controller: textController,
              readOnly: isReadOnly,
              enabled: !isReadOnly,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                
                // Remove todas as bordas do Input para usar a do Container
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                
                // Mensagem de erro flutuante (opcional, ajusta conforme gosto)
                errorStyle: TextStyle(height: 0.8), 
              ),
              validator: (value) {
                if (!isReadOnly && isRequired && (value == null || value.isEmpty)) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

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
      useRootNavigator: false,
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
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black54,
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
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
      default:
        actionText = '';
        actionColor = Colors.transparent;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isClienteModalLoading ? null : actionCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}