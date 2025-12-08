import 'package:fabrica_software_app/models/projeto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

class VisualizarProjetoScreen extends StatelessWidget {
  final Projeto projeto;

  const VisualizarProjetoScreen({super.key, required this.projeto});

  // --- LÓGICA DE ÍCONES ---
  IconData _getIcon() {
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
    final icon = _getIcon();
    final iconColor = _getIconColor();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Visualizar Projeto",
                  style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  projeto.nomeProjeto,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100), 
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 850;
                  final crossAxisCount = isDesktop ? 2 : 1;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isDesktop ? 2.2 : 1.5, 
                    
                    children: [
                      _DashboardInfoCard(
                        title: "Gestão de Recursos",
                        icon: Icons.people,
                        themeColor: const Color(0xFF1E40AF),
                        stats: const [
                          {"label": "Desenvolvedores", "value": "6 membros"},
                          {"label": "QA", "value": "3 membros"},
                          {"label": "Product Owner", "value": "1 membro"},
                        ],
                        buttonText: "Ver Recursos",
                        onPressed: () {},
                      ),

                      _DashboardInfoCard(
                        title: "Documentação e Artefatos",
                        icon: Icons.folder,
                        themeColor: const Color(0xFF16A34A),
                        subtitle: "Controle documentos e artefatos do projeto",
                        stats: const [
                          {"label": "Documentos", "value": "24 arquivos"},
                          {"label": "Versões", "value": "v3.2"},
                          {"label": "Última atualização", "value": "Hoje"},
                        ],
                        buttonText: "Ver Documentos",
                        onPressed: () {},
                      ),

                      _DashboardInfoCard(
                        title: "Relatórios de Treinamentos",
                        icon: FontAwesomeIcons.graduationCap,
                        themeColor: const Color(0xFFEA580C),
                        subtitle: "Controle treinamentos e capacitações",
                        stats: const [
                          {"label": "Treinamentos", "value": "5 concluídos"},
                          {"label": "Participantes", "value": "12 pessoas"},
                          {"label": "Certificações", "value": "10 emitidas"},
                        ],
                        buttonText: "Ver Treinamentos",
                        onPressed: () {},
                      ),

                      _DashboardInfoCard(
                        title: "Relatórios de Testes",
                        icon: Icons.bug_report,
                        themeColor: const Color(0xFF9333EA),
                        subtitle: "Gerencie relatórios de QA e validação",
                        stats: const [
                          {"label": "Testes executados", "value": "156"},
                          {"label": "Taxa de sucesso", "value": "94%", "valueColor": Colors.green},
                          {"label": "Bugs encontrados", "value": "8", "valueColor": Colors.red},
                        ],
                        buttonText: "Ver Relatórios",
                        onPressed: () {},
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR DO CARD ---
class _DashboardInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color themeColor;
  final String? subtitle;
  final List<Map<String, dynamic>> stats;
  final String buttonText;
  final VoidCallback onPressed;

  const _DashboardInfoCard({
    required this.title,
    required this.icon,
    required this.themeColor,
    this.subtitle,
    required this.stats,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(icon, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  if (subtitle != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      subtitle!,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                  ] else
                     const SizedBox(height: 24),

                  ...stats.map((stat) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stat['label'],
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        Text(
                          stat['value'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600, 
                            fontSize: 13,
                            color: stat['valueColor'] ?? const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(Icons.arrow_forward, size: 16, color: Colors.white),
              label: Text(buttonText, style: const TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}