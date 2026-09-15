import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startScan();
  }

  void _startScan(){
    // demora 5 segundos para realizar o scan. A aplicação só vai rodar depos do scan 
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispositivos Bluetooth"),
      actions: [
        IconButton(onPressed: _startScan, icon: Icon(Icons.refresh))
      ],),
      body: StreamBuilder<bool>(
        // primeiro stream para verificar a busca do bluetooth
        stream: FlutterBluePlus.isScanning, 
        initialData: false,
        builder: (context, snapshotScanning){
          final isScanning = snapshotScanning.data ?? false; // verificador de nulidade -> se for nulo, escreve falso
          // segundo stream para monitorar os dispositivos que estão disponiveis
          return StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.scanResults,
            initialData: [], // vetor vazio para armazenar os dispositivos bluetooth 
            builder: (context, snapshotResults){
              final dispositivos = snapshotResults.data ?? [];
              if(isScanning && dispositivos.isEmpty){
                return Center(child: CircularProgressIndicator(),); // buscando as informaçõs 
              } else if(dispositivos.isEmpty){
                return Center(child: Text("Nenhum dispositivo encontrado"),);
              } else {
                return ListView.builder(
                  itemCount: dispositivos.length,
                  itemBuilder: (context, index){
                    final item = dispositivos[index];
                    final name = item.device.platformName.isNotEmpty ? item.device.platformName : "Dispositivo sem nome";
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(item.device.remoteId.str),
                      trailing: Text("{$item.rssi} dBm"),
                      // frequencia da conexão -> se o sinal está forte ou nn 
                    );
                  });
              }
            });
        }),
    );
  }
}