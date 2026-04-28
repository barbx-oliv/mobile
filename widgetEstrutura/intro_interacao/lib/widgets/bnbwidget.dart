import 'package:flutter/material.dart';
// import 'package:intro_interacao/pages/contato_page.dart';
// import 'package:intro_interacao/pages/formulario_page.dart';
// import 'package:intro_interacao/pages/home_page.dart';

Widget BNBWidget {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Formulario"),
      BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: "Contato"),
    ],
    onTap: (value) => Navigator.pushNamed(context, routeName)),
  );
}