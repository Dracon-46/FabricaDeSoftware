import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.indigo],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Fábrica de Software',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.people,
            title: 'Usuários',
            route: '/usuarios',
          ),
          _DrawerItem(
            icon: Icons.business,
            title: 'Clientes',
            route: '/clientes',
          ),
          _DrawerItem(
            icon: Icons.folder_special,
            title: 'Projetos',
            route: '/projetos',
          ),
          _DrawerItem(
            icon: Icons.person_outline,
            title: 'Contribuidores',
            route: '/contribuidores',
          ),
          _DrawerItem(
            icon: Icons.emoji_objects,
            title: 'Recursos',
            route: '/recursos',
          ),
          _DrawerItem(
            icon: Icons.list_alt,
            title: 'Requisitos',
            route: '/requisitos',
          ),
          _DrawerItem(
            icon: Icons.computer,
            title: 'Tecnologias',
            route: '/tecnologias',
          ),
          _DrawerItem(
            icon: Icons.science,
            title: 'Testes',
            route: '/testes',
          ),
          _DrawerItem(
            icon: Icons.school,
            title: 'Treinamentos',
            route: '/treinamentos',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop(); // Fecha o drawer
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}