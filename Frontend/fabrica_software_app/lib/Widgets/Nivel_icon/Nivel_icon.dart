import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NivelIcon extends StatelessWidget {
  final String nivel;
  final Color? color;
  final double? size;
  const NivelIcon({super.key, required this.nivel, this.color,this.size});

  @override
  Widget build(BuildContext context) {
    late IconData icon=FontAwesomeIcons.x;
    if(nivel.toUpperCase()=='COLABORADOR'){
      icon=FontAwesomeIcons.dragon;
    }
    if(nivel.toUpperCase()=='ADMINISTRADOR'){
      icon=FontAwesomeIcons.userTie;
    }
    if(nivel.toUpperCase()=='ADMIN'){
      icon=FontAwesomeIcons.solidUser;
    }

    return FaIcon(icon,color: color,size: size) ;
  }
}