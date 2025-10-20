import 'package:flutter/material.dart';
import '../../../models/recurso.dart';
import 'recurso_list_item.dart';

class RecursoList extends StatelessWidget {
  final List<Recurso> recursos;

  const RecursoList({
    Key? key,
    required this.recursos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: recursos.length,
      itemBuilder: (ctx, i) => RecursoListItem(
        recurso: recursos[i],
        key: ValueKey(recursos[i].id),
      ),
    );
  }
}