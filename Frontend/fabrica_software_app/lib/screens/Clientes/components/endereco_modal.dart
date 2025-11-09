// --- Ficheiro: lib/widgets/endereco_modal.dart ---

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/endereco.dart';
// (Vamos assumir que terás um EnderecosProvider no futuro)
// import 'package:provider/provider.dart';
// import 'package:fabrica_software_app/providers/enderecos_provider.dart';

// 1. O ENUM (sem 'delete')
enum EnderecoModalMode {
  view,
  edit,
  create,
}

class EnderecoModal extends StatefulWidget {
  final EnderecoModalMode mode;
  final Endereco? endereco; // Endereço é opcional

  const EnderecoModal({
    super.key,
    required this.mode,
    this.endereco,
  });

  @override
  State<EnderecoModal> createState() => _EnderecoModalState();
}

class _EnderecoModalState extends State<EnderecoModal> {
  // 3. Controladores para TODOS os campos do Endereço
  late TextEditingController _logradouroController;
  late TextEditingController _cepController;
  late TextEditingController _numeroController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _paisController;
  late TextEditingController _complementoController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 4. Preenche os controladores (vazios se for 'create')
    _logradouroController = TextEditingController(text: widget.endereco?.logradouro ?? '');
    _cepController = TextEditingController(text: widget.endereco?.cep ?? '');
    _numeroController = TextEditingController(text: widget.endereco?.numero ?? '');
    _bairroController = TextEditingController(text: widget.endereco?.bairro ?? '');
    _cidadeController = TextEditingController(text: widget.endereco?.cidade ?? '');
    _estadoController = TextEditingController(text: widget.endereco?.estado ?? '');
    _paisController = TextEditingController(text: widget.endereco?.pais ?? '');
    _complementoController = TextEditingController(text: widget.endereco?.complemento ?? '');
  }

  @override
  void dispose() {
    // 5. Limpa TODOS os controladores
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

  // --- Funções Auxiliares ---

  Widget _buildHeader(BuildContext context) {
    String title;
    IconData icon;
    Color iconColor;

    switch (widget.mode) {
      case EnderecoModalMode.view:
        title = 'Detalhes do Endereço';
        icon = FontAwesomeIcons.locationDot;
        iconColor = Theme.of(context).primaryColor;
        break;
      case EnderecoModalMode.edit:
        title = 'Editar Endereço';
        icon = FontAwesomeIcons.mapLocationDot;
        iconColor = Colors.orange;
        break;
      case EnderecoModalMode.create:
        title = 'Criar Novo Endereço';
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
          onPressed: () => Navigator.pop(context), // Fecha este modal
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (widget.mode) {
      case EnderecoModalMode.view:
        return Column(
          children: [
            _buildReadOnlyField("Logradouro", widget.endereco!.logradouro),
            _buildReadOnlyField("CEP", widget.endereco!.cep),
            _buildReadOnlyField("Cidade", widget.endereco!.cidade),
            _buildReadOnlyField("Estado", widget.endereco!.estado),
            _buildReadOnlyField("País", widget.endereco!.pais),
          ],
        );
      
      case EnderecoModalMode.edit:
      case EnderecoModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField("Logradouro *", _logradouroController),
              _buildEditableField("CEP *", _cepController),
              _buildEditableField("Número", _numeroController, isRequired: false),
              _buildEditableField("Bairro", _bairroController, isRequired: false),
              _buildEditableField("Cidade *", _cidadeController),
              _buildEditableField("Estado (ex: SP) *", _estadoController),
              _buildEditableField("País *", _paisController),
              _buildEditableField("Complemento", _complementoController, isRequired: false),
            ],
          ),
        );
    }
  }

  Widget _buildFooter(BuildContext context) {
    if (widget.mode == EnderecoModalMode.view) {
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
      case EnderecoModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () { // (Falta async)
          if (_formKey.currentState?.validate() ?? false) {
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
            // TODO: Chamar o EnderecosProvider para ATUALIZAR
            // await context.read<EnderecosProvider>().atualizarEndereco(widget.endereco!.id!, data);
            print("Lógica de Atualizar Endereço: $data");
            
            // DEVOLVE O ID DO ENDEREÇO PARA O MODAL PAI
            Navigator.pop(context, widget.endereco!.id); 
          }
        };
        break;
      case EnderecoModalMode.create:
        actionText = 'Criar Endereço';
        actionColor = Colors.green;
        actionCallback = () { // (Falta async)
          if (_formKey.currentState?.validate() ?? false) {
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
            // TODO: Chamar o EnderecosProvider para CRIAR
            // final novoEndereco = await context.read<EnderecosProvider>().criarEndereco(data);
            print("Lógica de Criar Endereço: $data");
            
            // Simula um novo ID
            final int novoIdSimulado = 2; 
            
            // DEVOLVE O NOVO ID PARA O MODAL PAI
            Navigator.pop(context, novoIdSimulado); 
          }
        };
        break;
      default:
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