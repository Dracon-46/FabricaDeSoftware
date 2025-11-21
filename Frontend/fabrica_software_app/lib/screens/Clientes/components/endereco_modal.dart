// --- Ficheiro: lib/widgets/endereco_modal.dart ---

import 'package:fabrica_software_app/providers/endereco_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/endereco.dart';

enum EnderecoModalMode {
  view,
  edit,
  create,
}

class EnderecoModal extends StatefulWidget {
  final EnderecoModalMode mode;
  final Endereco? endereco;
  final EnderecosProvider enderecosProvider;

  const EnderecoModal({
    super.key,
    required this.mode,
    required this.enderecosProvider,
    this.endereco,
  });

  @override
  State<EnderecoModal> createState() => _EnderecoModalState();
}

class _EnderecoModalState extends State<EnderecoModal> {
  late TextEditingController _logradouroController;
  late TextEditingController _cepController;
  late TextEditingController _numeroController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _paisController;
  late TextEditingController _complementoController;

  final _formKey = GlobalKey<FormState>();
  bool _isModalLoading = false;

  // --- ESTILOS ---
  
  final BoxDecoration _inputBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10), 
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 4,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
    ],
    border: Border.all(color: const Color.fromARGB(255, 230, 230, 230)),
  );

  @override
  void initState() {
    super.initState();
    _logradouroController = TextEditingController(text: widget.endereco?.logradouro ?? '');
    _cepController = TextEditingController(text: widget.endereco?.cep ?? '');
    _numeroController = TextEditingController(text: widget.endereco?.numero ?? '');
    _bairroController = TextEditingController(text: widget.endereco?.bairro ?? '');
    _cidadeController = TextEditingController(text: widget.endereco?.cidade ?? '');
    _estadoController = TextEditingController(text: widget.endereco?.estado ?? '');
    _paisController = TextEditingController(text: widget.endereco?.pais ?? 'Brasil');
    _complementoController = TextEditingController(text: widget.endereco?.complemento ?? '');
  }

  @override
  void dispose() {
    _logradouroController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _paisController.dispose();
    _complementoController.dispose();
    super.dispose();
  }
  
  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() { _isModalLoading = true; });

    final provider = widget.enderecosProvider;

    final data = {
      'logradouro': _logradouroController.text,
      'cep': _cepController.text,
      'numero': _numeroController.text.isEmpty ? null : _numeroController.text,
      'bairro': _bairroController.text.isEmpty ? null : _bairroController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
      'pais': _paisController.text,
      'complemento': _complementoController.text.isEmpty ? null : _complementoController.text,
    };

    try {
      if (widget.mode == EnderecoModalMode.edit) {
        final enderecoAtualizado = await provider.atualizarEndereco(widget.endereco!.id!, data);
        if (!mounted) return;
        Navigator.pop(context, enderecoAtualizado.id);

      } else if (widget.mode == EnderecoModalMode.create) {
        final novoEndereco = await provider.criarEndereco(data);
        if (!mounted) return;
        Navigator.pop(context, novoEndereco.id);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar endereço: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() { _isModalLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const Divider(height: 24, thickness: 0.5, color: Colors.grey),
              Flexible(
                child: SingleChildScrollView(
                  child: _isModalLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _buildBody(context),
                ),
              ),
              const SizedBox(height: 16),
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
      case EnderecoModalMode.view:
        title = 'Endereço';
        icon = FontAwesomeIcons.locationDot;
        iconColor = const Color(0xFF2962FF);
        bgColorIcon = const Color(0xFFE3F2FD);
        break;
      case EnderecoModalMode.edit:
        title = 'Editar Endereço';
        icon = FontAwesomeIcons.mapLocationDot;
        iconColor = Colors.orange;
        bgColorIcon = Colors.orange.shade50;
        break;
      case EnderecoModalMode.create:
        title = 'Novo Endereço';
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
          child: FaIcon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              color: Colors.black87
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    String? getText(String? val) => widget.mode == EnderecoModalMode.view ? val : null;
    TextEditingController? getCtrl(TextEditingController ctrl) => widget.mode != EnderecoModalMode.view ? ctrl : null;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logradouro (Full)
        _buildLabelAndField(
          "Logradouro *", 
          textValue: getText(widget.endereco?.logradouro),
          controller: getCtrl(_logradouroController)
        ),

        // Número + CEP
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Garante alinhamento topo
          children: [
            Expanded(
              flex: 3,
              child: _buildLabelAndField(
                "Número", 
                textValue: getText(widget.endereco?.numero ?? ''),
                controller: getCtrl(_numeroController),
                isRequired: false
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 7,
              child: _buildLabelAndField(
                "CEP *", 
                textValue: getText(widget.endereco?.cep),
                controller: getCtrl(_cepController),
                isNumeric: true
              ),
            ),
          ],
        ),

        // Bairro + Complemento
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildLabelAndField(
                "Bairro", 
                textValue: getText(widget.endereco?.bairro ?? ''),
                controller: getCtrl(_bairroController),
                isRequired: false
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: _buildLabelAndField(
                "Complemento", 
                textValue: getText(widget.endereco?.complemento ?? ''),
                controller: getCtrl(_complementoController),
                isRequired: false
              ),
            ),
          ],
        ),

        // Cidade + UF + País
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildLabelAndField(
                "Cidade *", 
                textValue: getText(widget.endereco?.cidade),
                controller: getCtrl(_cidadeController)
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildLabelAndField(
                "UF *", 
                textValue: getText(widget.endereco?.estado),
                controller: getCtrl(_estadoController)
              ),
            ),
            const SizedBox(width: 12),
             Expanded(
              flex: 3,
              child: _buildLabelAndField(
                "País *", 
                textValue: getText(widget.endereco?.pais),
                controller: getCtrl(_paisController)
              ),
            ),
          ],
        ),
      ],
    );

    if (widget.mode == EnderecoModalMode.view) {
      return content;
    }
    
    return Form(key: _formKey, child: content);
  }

  Widget _buildLabelAndField(String label, {String? textValue, TextEditingController? controller, bool isRequired = true, bool isNumeric = false}) {
    bool isReadOnly = widget.mode == EnderecoModalMode.view;
    final textController = controller ?? TextEditingController(text: textValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),

          Container(
            // CORREÇÃO: Removi o height: 42 fixo.
            // A altura agora é definida pelo padding interno + tamanho da fonte.
            decoration: _inputBoxDecoration,
            child: TextFormField(
              controller: textController,
              readOnly: isReadOnly,
              enabled: !isReadOnly,
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              // CORREÇÃO: Ajustei o padding interno para centralizar e dar "respiro"
              decoration: const InputDecoration(
                isDense: true, 
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: TextStyle(height: 0, fontSize: 0),
              ),
              validator: (value) {
                if (!isReadOnly && isRequired && (value == null || value.isEmpty)) {
                  return ''; 
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (widget.mode == EnderecoModalMode.view) {
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
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Fechar'),
          ),
        ],
      );
    }

    String actionText;
    Color actionColor;
    VoidCallback? actionCallback = _submitForm;

    switch (widget.mode) {
      case EnderecoModalMode.edit:
        actionText = 'Salvar';
        actionColor = Theme.of(context).primaryColor;
        break;
      case EnderecoModalMode.create:
        actionText = 'Criar';
        actionColor = Colors.green;
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
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isModalLoading ? null : actionCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            visualDensity: VisualDensity.compact,
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}