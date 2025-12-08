import 'package:fabrica_software_app/screens/Gerenciar_Projetos/components/visualizador_Projetos_Screen.dart'; // Ajuste o caminho
import 'package:flutter/material.dart';
import 'package:fabrica_software_app/models/projeto.dart';

class ProjectCard extends StatelessWidget {
  final Projeto projeto;

  const ProjectCard({super.key, required this.projeto});

  // --- LÓGICA DE CORES E ÍCONES ---

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Concluído': return Colors.blue.shade700;
      case 'Atrasado': return Colors.red.shade700;
      default: return Colors.green.shade700;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Concluído': return Colors.blue.shade50;
      case 'Atrasado': return Colors.red.shade50;
      default: return Colors.green.shade50;
    }
  }

  IconData _getIcon() {
    // Prioriza o 'tipo', se não tiver, usa 'modeloProjeto'
    final tipoVerificado = (projeto.tipo ?? '').toUpperCase();
    final fallback = tipoVerificado.isNotEmpty ? tipoVerificado : (projeto.modeloProjeto ?? '').toUpperCase();

    if (fallback.contains('WEB')) return Icons.language;
    if (fallback.contains('MOBILE') || fallback.contains('APP') || fallback.contains('ANDROID')) return Icons.smartphone;
    if (fallback.contains('API') || fallback.contains('BACKEND')) return Icons.storage;
    if (fallback.contains('DESKTOP') || fallback.contains('WINDOWS')) return Icons.monitor;
    if (fallback.contains('DATA') || fallback.contains('DADOS')) return Icons.analytics;
    
    return Icons.folder_open;
  }

  Color _getIconColor() {
    final tipoVerificado = (projeto.tipo ?? '').toUpperCase();
    final fallback = tipoVerificado.isNotEmpty ? tipoVerificado : (projeto.modeloProjeto ?? '').toUpperCase();

    if (fallback.contains('WEB')) return Colors.blue;
    if (fallback.contains('MOBILE') || fallback.contains('APP')) return Colors.purple;
    if (fallback.contains('API')) return Colors.orange;
    if (fallback.contains('DESKTOP')) return Colors.indigo;
    if (fallback.contains('DATA')) return Colors.teal;
    
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final status = projeto.statusCalculado;
    final statusColor = _getStatusColor(status);
    final statusBgColor = _getStatusBgColor(status);
    final icon = _getIcon();
    final iconColor = _getIconColor();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisualizarProjetoScreen(projeto: projeto),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 230, 228, 228)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projeto.nomeProjeto,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            projeto.clienteNome ?? 'Cliente #${projeto.clienteId}',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // DESCRIÇÃO
                Text(
                  projeto.descricao ?? 'Sem descrição',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                ),

                const Spacer(),

                // FOOTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 14,
                              child: const Icon(Icons.person, size: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      // Mostra o TIPO se existir, senão o modelo
                      projeto.tipo ?? projeto.modeloProjeto ?? 'Geral',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}