import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    //sistema de rotas para navegação entre telas
    //home: -> tela inicial
    //form: -> tela de formulário
    //contato: -> tela de contato
    routes: 
      {
        "/": (context) => Home(),
        "/form": (context) => FormularioPage(),
        "/contato": (context) => ContatoPage(),
      }
    ,
    initialRoute: "/", // Direciona o aplicativo para a homepage ao abrir 
  ));
} 
