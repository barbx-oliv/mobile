// Aplicativo usando StateFul (com mudança de estado --> ReBuild da tela)


import 'package:flutter/material.dart';


void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});


  // Método que identifica as mudanças de estado e chama a reconstrução da tela
  @override
  State<MyApp> createState() => _MyAppState();
   // Arrow function
}


// Classe criada para construir a janela, toda ação é escrita aqui
class _MyAppState extends State<MyApp> {
  //variável para identificar o nº de cliques no botão
  int contador = 0;


  // Build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aplicativo comStateFul - Contador"),),
      // Container Padding --> Espaçamento interno
      body: Padding (
        // Espaçamento em todos os lados de 8px
        padding: EdgeInsets.all(8),
        // Container Center --> Centraliza os elementos no meio da tela (lateral - margem direita e esquerda)
        child: Center(
          // Column permite adiionar mais de elemento
          child: Column(
            // Centraliza os elemntos com relação ao Top e Botton
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Número de Cliques: $contador", style: TextStyle(fontSize: 20)),
              // Adicionar um botão --> Permite criar uma ação, ao ser pressionado
              ElevatedButton(
                onPressed: (){
                  // Adicionar setState
                  setState(() {
                    // Colocar a ação para o botão
                    contador++; // Adiciona o contador em +1
                  });
                }, // Ação do botão (){} ou () =>
                child: Text("Adicionar +1"))
            ],
          ),
        ),),
    );
  }
}

