import 'dart:async'; // biblioteca do dart para uar o stream
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Criação de uma mensagem 
  String _mensagem = "verificando...";

  // Criação de objeto para "ouvir" as mudançãs de conexão wifi
  // o stream vai anunciar a mudança do status da conexão
  // o stream é a classe que faz o monitoramento do connectivity result, mas ele pode fazer o monitoramento de outras coisas
  late StreamSubscription<List<ConnectivityResult>> _wifiObserver;

  // Métodos
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Fazer check do wifi
    _checkInitialConnection();
    // 2. Começar a ouvir as mudanças de conexão em tempo real
    // vai ficar armazenado em formato de lista
    _wifiObserver = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results){
      // Pega o primeiro resultado disponivel ou connectivityresult.none se a lista estiver vazia 
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  // Continuidade dos métodos 
  void _checkInitialConnection() async{ // é async pq vai verificar alguma coisa 
  // var -> variavel que vai receber algum valor 
    var _connectivityResult = (await Connectivity().checkConnectivity() as ConnectivityResult);
      _updateConnectionStatus(_connectivityResult);
  }

  // Método para identificar mudanças de conexão wifi 
  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          _mensagem = "Conectado no WIFI";
        break;
        case ConnectivityResult.mobile:
          _mensagem = "Conectado via Dados Moveis";
        break;
        case ConnectivityResult.none:
          _mensagem = "Sem conexão com a internet";
        break;
        default:
       _mensagem = "Procurando conexão...";
        break;
      }
    });
  }

  // limpa ao memoria ao sair da tela 
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _wifiObserver.cancel(); // interrompeu

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Status da Conexão"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              // O icone vai mudar de acordo com a conexão 
              _mensagem.contains("WIFI") ? Icons.wifi :
              _mensagem.contains("Dados") ? Icons.network_cell : 
              Icons.wifi_off,
              size: 80,
              color: _mensagem.contains("Sem") ? Colors.red : Colors.green,
            ),
            SizedBox(height: 10,),
            Text("Status: $_mensagem")
          ],
        ),
      ),
    );
  }
}