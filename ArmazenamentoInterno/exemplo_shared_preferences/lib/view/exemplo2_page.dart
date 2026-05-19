import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo2Page extends StatefulWidget {
  const Exemplo2Page({super.key});

  @override
  State<Exemplo2Page> createState() => _Exemplo2PageState();
}

class _Exemplo2PageState extends State<Exemplo2Page> {
  late SharedPreferences _prefs; 
  // Inicialmente ele vai ser um obj nulo, depois ele vai receber o valor e pode alterar quantas vezes for necessário  
  // O scopo final inicial ele é nulo e permite a alteração muda apenas uma vez 
  bool _darkMode = false;

  // métodos de conexão com o SharedPreferences
  @override 
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async{
    _prefs = await
    
    SharedPreferences.getInstance(); // Pega as informações salvas no shared
    setState(() {
      _darkMode = _prefs.getBool("darkMode") ?? false;
      // Verificação de nulidade obrigatória, ?? se caso a chave darkMode do shared seja nula(não tenha o valor atribuido ainda) a variável _darkMode será false 
    });
  }
  
  // Método para salvar dados no Shared 
  void savePreferences() async {
    setState(() {
      _darkMode = !_darkMode; // Invertendo o valor da booleana. Se dark mode inicialmente é fácil, agora ela passa a ser o inverso 
    });
    await _prefs.setBool("darkMode", _darkMode); // Estou atribuindo o valor da variável _darkMode a chave darkmode do Shared

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modo Escuto com Shared Preferences"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tema Atual: ${_darkMode ? "Escuro" : "Claro"}"),
            Switch(
              value: _darkMode, 
              onChanged: (_)=>savePreferences())
          ],
        ),
      ),
    );
  }
}