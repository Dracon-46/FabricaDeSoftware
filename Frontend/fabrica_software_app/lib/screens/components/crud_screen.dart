import 'package:flutter/material.dart';

class CrudScreen<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRefresh;
  final Future<void> Function(T item) onAdd;
  final Future<void> Function(T item) onUpdate;
  final Future<void> Function(String id) onDelete;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, {T? item}) formBuilder;

  const CrudScreen({
    super.key,
    required this.title,
    required this.items,
    required this.isLoading,
    this.error,
    required this.onRefresh,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    required this.itemBuilder,
    required this.formBuilder,
  });

  @override
  State<CrudScreen<T>> createState() => _CrudScreenState<T>();
}

class _CrudScreenState<T> extends State<CrudScreen<T>> {
  @override
  void initState() {
    super.initState();
    widget.onRefresh();
  }

  Future<void> _showForm({T? item}) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? 'Novo Item' : 'Editar Item'),
        content: widget.formBuilder(ctx, item: item),
      ),
    );
  }

  Future<void> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await widget.onDelete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro: ${widget.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.onRefresh,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
          : widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: widget.onRefresh,
                  child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return widget.itemBuilder(context, item);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}