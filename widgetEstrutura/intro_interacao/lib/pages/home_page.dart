// Tela inicial 
// Vai ter botões de navegação para outras telas 

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title: Text("Meu Aplicativo Interativo"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            // Alinhamento do eixo principal(vertical)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://i.pinimg.com/736x/b2/ac/33/b2ac33eff13a60302d3cf2f58e97a009.jpg",
              width: 150,
              height: 150,),
              SizedBox(height: 20,),
              // Bitões de Navegação 
              ElevatedButton(
                // Métodos de Navegação para a Tela de Formulário
                onPressed: () => Navigator.pushNamed(context, "/form"), 
                // Texto do Botão 
                child: Text("Formulário")),
              SizedBox(height: 10,),
              ElevatedButton(
                //método de navegação para a tela de formualário
                onPressed: ()=> Navigator.pushNamed(context, "/contato"),
                //texto do botão
                child: Text("Contato")),
            ],
          ),
        ),),
    );
  }
}