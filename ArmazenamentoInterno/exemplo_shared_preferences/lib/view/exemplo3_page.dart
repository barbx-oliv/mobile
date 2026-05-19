import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo3Page extends StatefulWidget {
  const Exemplo3Page({super.key});

  @override
  State<Exemplo3Page> createState() => _Exemplo3PageState();
}

class _Exemplo3PageState extends State<Exemplo3Page> {
  List<String> _tarefas = []; // armazenar as tarefas
  final TextEditingController _inputTarefa = TextEditingController(); // Controlar o input de tarefas
  late SharedPreferences _prefs;
  String nome = "";

  // Métodos
  @override
    void initState() {
      super.initState();
      _loadTarefas;
    }

    // Carregar dados do Shared 
    Future<void> _loadTarefas() async {
      // Conectar o App ao Shared
      _prefs = await SharedPreferences.getInstance();
      nome = _prefs.getString("nome") ?? ""; // Verificação de nulidade
      setState(() {
        _tarefas = _prefs.getStringList("tarefas") ?? [];
      });
    }

    // Salvar dados no shared
    void _savePreferences() async {
      _prefs = await SharedPreferences.getInstance();
      nome = _prefs.getString("nome") ?? "";
      // Salvar as preferencias 
      await _prefs.setStringList("tarefas+$nome", _tarefas);
      setState(() {
        
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Tarefas do $nome !"),),
      body: Padding(padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _inputTarefa,
            decoration: InputDecoration(labelText: "Digite a tarefa..."),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tarefas.add(_inputTarefa.text.trim()); // Adicionar a tarefa no vetor 
                _savePreferences(); // Salvar no shared 
              });
            }, child: Text("Adicionar")),
              SizedBox(height: 20,),
              // Listar as tarefas 
              Expanded(
                child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(_tarefas[index]),
                      onLongPress: () {
                        _tarefas.removeAt(index); // Remove a tarefa
                        _savePreferences(); // Salva no Shared
                      },
                    );
                  }))
        ],
      ),
      
      ),
    );
  }
}