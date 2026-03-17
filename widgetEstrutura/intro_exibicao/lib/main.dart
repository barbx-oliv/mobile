// tela para estudo dos widgets de exibição
//  text, image, icon entre outros

import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp( // o sor gosta de colocar o MAterialApp no void main 
   // Configurações iniciais do App 
  // Router => rotas de navegação 
  // Home => pagina inicial  
  // ThemeApp => (claro, escuro)
  home: MyApp(),
  )); 

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Estrutura da Tela (build)
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Elemento principal da tela 
    // AppBar, Drawer, bnBar, body, fabutton, Snakebar
    appBar: AppBar(title: Text("Exemplos de Widget de Exibição"),),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        //Widget de Text
        // Adicionar um Container
        child: Expanded(
          child: Column(
          children: [
            Text(
              "Explorando o Flutter", 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ),
              ),
              // Dentro da column nos vamos adicionar uma imagem 
              Image.network(
                "https://upload-os-bbs.hoyolab.com/upload/2024/07/14/107297633/d17b40e25e1f09c4df6a0427b48859aa_8644224556849995819.jpg",
                height: 350,
                fit: BoxFit.contain,),
              
              Image.asset("assets/img/neuvi.webp",
                height: 250,
                fit: BoxFit.cover,)
                
          ],
        )
        ),
        ),
    ),
    );
  }
}