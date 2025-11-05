import 'package:fabrica_software_app/Widgets/Nivel_icon/Nivel_icon.dart';
import 'package:fabrica_software_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'styles/Barra_Lateral_Styles.dart';

class BarraLateral extends StatelessWidget {

  const BarraLateral({super.key});



  @override
  Widget build(BuildContext context) {
    final _authProvider = context.watch<AuthProvider>();
    return Drawer(
      backgroundColor:Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, 
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 80.0, 
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 44, 100, 253),
            ),
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding( 
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(children: <Widget>[
                    Image.asset('assets/image/icone_logo.png', height: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Fabrica Software',
                      style: TextStyle(color: Colors.white,
                      fontWeight:FontWeight.w500, 
                      fontSize: 24),
                    ),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: FaIcon(FontAwesomeIcons.x),color: Colors.white,iconSize: 15,)
                  ]),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.folderOpen),
                  title: Text('Projetos',style: Barra_Lateral_Styles.TextStyleButtons,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/Gerenciar_Projetos');
                  },
                ),

                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.peopleGroup),
                  title: Text('Equipe',style: Barra_Lateral_Styles.TextStyleButtons,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),

                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.chartBar),
                  title: Text('Relatórios',style: Barra_Lateral_Styles.TextStyleButtons,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),

                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.usersGear),
                  title: Text('Gestão de Usuários',style: Barra_Lateral_Styles.TextStyleButtons,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/Usuarios');
                  },
                ),

                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.users),
                  title: Text('Gestão de Clientes',style: Barra_Lateral_Styles.TextStyleButtons,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/Cadastro');
                  },
                ),

              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child:MouseRegion(
                    cursor:SystemMouseCursors.click,
                      child:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          NivelIcon(nivel:'${_authProvider.userNivel}',color:Barra_Lateral_Styles.Usercolor,),
                          const SizedBox(width: 13),
                          Text('${_authProvider.userNivel?.toUpperCase()}',style:TextStyle(color: Barra_Lateral_Styles.Usercolor,fontWeight: FontWeight.w500),),
                        ]
                      ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/Account');
                  },
                ),
                IconButton(
                  tooltip: 'Sair da conta',
                  onPressed: () {
                    _authProvider.logout();
                     Navigator.pushReplacementNamed(context,'/');
                  },
                  icon: FaIcon(FontAwesomeIcons.rightFromBracket,color: const Color.fromARGB(255, 179, 45, 36),)
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}