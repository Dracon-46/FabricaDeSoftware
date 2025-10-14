import 'package:flutter/material.dart';

class FormField {
  final String name;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool readOnly;

  const FormField({
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.readOnly = false,
  });
}

class CrudForm extends StatefulWidget {
  final List<FormField> fields;
  final Map<String, dynamic> initialData;
  final Future<void> Function(Map<String, dynamic> data) onSubmit;
  final String submitLabel;
  final bool isLoading;

  const CrudForm({
    super.key,
    required this.fields,
    required this.initialData,
    required this.onSubmit,
    this.submitLabel = 'Salvar',
    this.isLoading = false,
  });

  @override
  State<CrudForm> createState() => _CrudFormState();
}

class _CrudFormState extends State<CrudForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field.name] = TextEditingController(
        text: widget.initialData[field.name]?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{};
      for (var field in widget.fields) {
        data[field.name] = _controllers[field.name]!.text;
      }
      await widget.onSubmit(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.fields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _controllers[field.name],
                  decoration: InputDecoration(
                    labelText: field.label,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: field.keyboardType,
                  obscureText: field.obscureText,
                  validator: field.validator,
                  readOnly: field.readOnly,
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: widget.isLoading ? null : _submit,
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(widget.submitLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}