import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fabrica_software_app/models/recurso.dart';
import 'package:provider/provider.dart';
import 'package:fabrica_software_app/providers/recursos_provider.dart';

enum RecursoModalMode {
  view,
  edit,
  delete,
  create,
}

class RecursoModal extends StatefulWidget {
  final RecursoModalMode mode;
  final Recurso? recurso; 

  const RecursoModal({
    super.key,
    required this.mode,
    this.recurso,
  });

  @override
  State<RecursoModal> createState() => _RecursoModalState();
}

class _RecursoModalState extends State<RecursoModal> {
  // Controladores para os campos de Recurso
  late TextEditingController _nomeController;
  late TextEditingController _tipoController;
  late TextEditingController _descricaoController;
  late TextEditingController _criadoPorIdController;
  late bool _disponivel;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com dados do recurso, se houver
    _nomeController = TextEditingController(text: widget.recurso?.nome ?? '');
    _tipoController = TextEditingController(text: widget.recurso?.tipo ?? '');
    _descricaoController = TextEditingController(text: widget.recurso?.descricao ?? '');
    // Seguindo o padrão do seu modal de cliente (endereco_id),
    // 'criado_por_id' será um campo de texto numérico.
    // Em um app real, isso viria do usuário logado.
    _criadoPorIdController = TextEditingController(text: widget.recurso?.criadoPorId?.toString() ?? '');
    _disponivel = widget.recurso?.disponivel ?? true;
  }

  @override
  void dispose() {
    // Limpa os controladores
    _nomeController.dispose();
    _tipoController.dispose();
    _descricaoController.dispose();
    _criadoPorIdController.dispose();
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
      case RecursoModalMode.view:
        title = 'Detalhes do Recurso';
        icon = FontAwesomeIcons.solidEye;
        iconColor = Theme.of(context).primaryColor;
        break;
      case RecursoModalMode.edit:
        title = 'Editar Recurso';
        icon = FontAwesomeIcons.solidPenToSquare;
        iconColor = Colors.orange;
        break;
      case RecursoModalMode.delete:
        title = 'Excluir Recurso';
        icon = FontAwesomeIcons.trash;
        iconColor = Colors.red;
        break;
      case RecursoModalMode.create:
        title = 'Criar Novo Recurso';
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
      case RecursoModalMode.view:
        return Column(
          children: [
            _buildReadOnlyField("Nome", widget.recurso!.nome),
            _buildReadOnlyField("Tipo", widget.recurso!.tipo),
            _buildReadOnlyField("Disponível", widget.recurso!.disponivel ? 'Sim' : 'Não'),
            _buildReadOnlyField("Descrição", widget.recurso!.descricao ?? 'N/A'),
            _buildReadOnlyField("Criado Por ID", widget.recurso!.criadoPorId.toString()),
            _buildReadOnlyField("Data Criação", widget.recurso!.dataCriacao.toString()),
          ],
        );
      
      case RecursoModalMode.edit:
      case RecursoModalMode.create:
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField("Nome *", _nomeController),
              _buildEditableField("Tipo *", _tipoController),
              _buildEditableField("Descrição", _descricaoController, isRequired: false),
              _buildEditableField("ID Criador *", _criadoPorIdController, isNumeric: true),
              SwitchListTile(
                title: const Text('Disponível'),
                value: _disponivel,
                onChanged: (val) => setState(() => _disponivel = val),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      
      case RecursoModalMode.delete:
        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              const TextSpan(text: 'Você tem certeza que deseja excluir o recurso '),
              TextSpan(
                text: widget.recurso!.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nEsta ação não pode ser desfeita e pode afetar projetos que o utilizam.'),
            ],
          ),
        );
    }
  }

  Widget _buildFooter(BuildContext context) {
    // Não mostrar footer no modo 'view'
    if (widget.mode == RecursoModalMode.view) {
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

    // Define o texto, cor e ação do botão principal
    switch (widget.mode) {
      case RecursoModalMode.edit:
        actionText = 'Salvar Alterações';
        actionColor = Theme.of(context).primaryColor;
        actionCallback = () async {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'nome': _nomeController.text,
              'tipo': _tipoController.text,
              'disponivel': _disponivel,
              'descricao': _descricaoController.text.isEmpty ? null : _descricaoController.text,
              // CORREÇÃO: Removido 'criado_por_id' do 'data' de atualização.
              // Este campo não deve ser alterado.
            };
            await context.read<RecursosProvider>().atualizarRecurso(widget.recurso!.id!, data);
            Navigator.pop(context);
          }
        };
        break;
      case RecursoModalMode.delete:
        actionText = 'Excluir';
        actionColor = Colors.red;
        actionCallback = () async {
          await context.read<RecursosProvider>().excluirRecurso(widget.recurso!.id!);
          Navigator.pop(context);
        };
        break;
      case RecursoModalMode.create:
        actionText = 'Criar Recurso';
        actionColor = Colors.green;
        actionCallback = () async {
          if (_formKey.currentState?.validate() ?? false) {
            final data = {
              'nome': _nomeController.text,
              'tipo': _tipoController.text,
              'disponivel': _disponivel,
              'descricao': _descricaoController.text.isEmpty ? null : _descricaoController.text,
              'criado_por_id': int.parse(_criadoPorIdController.text),
            };
            await context.read<RecursosProvider>().criarRecurso(data);
            Navigator.pop(context);
          }
        };
        break;
      case RecursoModalMode.view:
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

  // Helper para campo de visualização
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

  // Helper para campo de edição (copiado do seu Cliente_modal)
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