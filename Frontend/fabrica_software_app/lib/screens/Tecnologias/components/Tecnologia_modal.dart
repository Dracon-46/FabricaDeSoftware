import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/tecnologia.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/tecnologias_provider.dart';

enum TecnologiaModalMode {
  view,
  edit,
  delete,
  create,
}

class TecnologiaModal extends StatefulWidget {
  final TecnologiaModalMode mode;
  final Tecnologia? tecnologia; 

  const TecnologiaModal({
    super.key,
    required this.mode,
    this.tecnologia,
  });

  @override
  State<TecnologiaModal> createState() => _TecnologiaModalState();
}

class _TecnologiaModalState extends State<TecnologiaModal> {
  // Controladores para os campos de Tecnologia
  late TextEditingController _nomeController;
  late TextEditingController _categoriaController;
  late TextEditingController _descricaoController;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com dados, se houver
    _nomeController = TextEditingController(text: widget.tecnologia?.nome ?? '');
    _categoriaController = TextEditingController(text: widget.tecnologia?.categoria ?? '');
    _descricaoController = TextEditingController(text: widget.tecnologia?.descricao ?? '');
  }

  @override
  void dispose() {
    // Limpa os controladores
    _nomeController.dispose();
    _categoriaController.dispose();
    _descricaoController.dispose();
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
      case TecnologiaModalMode.view:
        title = 'Detalhes da Tecnologia';
        icon = FontAwesomeIcons.solidEye;
        iconColor = Theme.of(context).primaryColor;
        break;
      case TecnologiaModalMode.edit:
        title = 'Editar Tecnologia';
        icon = FontAwesomeIcons.solidPenToSquare;
        iconColor = Colors.orange;
        break;
      case TecnologiaModalMode.delete:
        title = 'Excluir Tecnologia';
        icon = FontAwesomeIcons.trash;
        iconColor = Colors.red;
        break;
      case TecnologiaModalMode.create:
        title = 'Criar Nova Tecnologia';
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
      case TecnologiaModalMode.view:
        return Column(
          children: [
            _buildReadOnlyField("Nome", widget.tecnologia!.nome),
            _buildReadOnlyField("Categoria", widget.tecnologia!.categoria ?? 'N/A'),
            _buildReadOnlyField("Descrição", widget.tecnologia!.descricao ?? 'N/A'),
          ],
        );
      
      case TecnologiaModalMode.edit:
      case TecnologiaModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField("Nome *", _nomeController),
              _buildEditableField("Categoria", _categoriaController, isRequired: false),
              _buildEditableField("Descrição", _descricaoController, isRequired: false, maxLines: 3),
            ],
          ),
        );
      
      case TecnologiaModalMode.delete:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              const TextSpan(text: 'Você tem certeza que deseja excluir a tecnologia '),
              TextSpan(
                text: widget.tecnologia!.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nEsta ação não pode ser desfeita.'),
            ],
          ),
        );
    }
  }

  Widget _buildFooter(BuildContext context) {
    if (widget.mode == TecnologiaModalMode.view) {
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
      case TecnologiaModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () async {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'nome': _nomeController.text,
              'categoria': _categoriaController.text.isEmpty ? null : _categoriaController.text,
              'descricao': _descricaoController.text.isEmpty ? null : _descricaoController.text,
            };
            await context.read<TecnologiasProvider>().atualizarTecnologia(widget.tecnologia!.id!, data);
            Navigator.pop(context);
          }
        };
        break;
      case TecnologiaModalMode.delete:
        actionText = 'Excluir';
        actionColor = Colors.red;
        actionCallback = () async {
          await context.read<TecnologiasProvider>().excluirTecnologia(widget.tecnologia!.id!);
          Navigator.pop(context);
        };
        break;
      case TecnologiaModalMode.create:
        actionText = 'Criar Tecnologia';
        actionColor = Colors.green;
        actionCallback = () async {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'nome': _nomeController.text,
              'categoria': _categoriaController.text.isEmpty ? null : _categoriaController.text,
              'descricao': _descricaoController.text.isEmpty ? null : _descricaoController.text,
            };
            await context.read<TecnologiasProvider>().criarTecnologia(data);
            Navigator.pop(context);
          }
        };
        break;
      case TecnologiaModalMode.view:
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
        maxLines: null, // Permite que o campo cresça
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {bool isRequired = true, bool isNumeric = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          alignLabelWithHint: maxLines > 1 ? true : false, // Alinha label no topo para multiline
        ),
        keyboardType: isNumeric ? TextInputType.number : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
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