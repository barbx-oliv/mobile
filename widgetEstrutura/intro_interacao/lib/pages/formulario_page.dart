// Tela com Elementos de Formulário para Interação do Usuário
// textField -> Entrada de Dados
// Checkbox -> Seleção de Opções
// Radio Button -> Uma Única Opção
// Slider -> Barra de Seleção 
// Switch -> Botão de Alternância 
// DropDown -> Menu Suspenso 

// usar elemento form para validação de campos

import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  //atributos (nome, email, senha, validação de senha, termos de uso(switch), sexo(radio), idade(slider), interesses(chechbox), Cidade(dropdown) )
  String _nome = ""; //TextField
  String _email = ""; //TextField
  String _senha = "";// TextField => obscureText
  String _confirmarSenha = "";//Texfield => obscureText
  bool _aceitarTermos = false; // Switch
  String _sexo = "Feminino"; // Radio Button
  double _idade = 18; // Slider
  List<String> _interesses = []; //CheckBox
  String _cidade = "Americana"; // DropDown

  // Variavel booleana para ocultar senha
  bool _senhaOculta = true;

  //chave global de validação do formulário
  final formKey = GlobalKey<FormState>(); // formulário somente será enviado se a chave estiver validada


  //método que contém a lógica de construção da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de Cadastro"),),
      body: Padding(
        //espaçamento geral de 8px em toda a tela
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey, //chave de validação
          child: SingleChildScrollView( // permite a rolagem/scroll da tela
            child: Column(
              children: [
                //campo do nome
                TextFormField(
                  //validação do campo
                  validator: (value) => value!.isEmpty ? "Campo Obrigatório" : null,
                  onChanged: (value) => setState(() {_nome = value;}),// atribui para o _nome o valor do TextField
                  //labeltext => placeholder do campo // border => borda externa do campo
                  decoration: InputDecoration(labelText:"Digite seu nome...", border: OutlineInputBorder()),
                ),
                SizedBox(height: 10,),
                //campo email
                TextFormField(
                  validator: (value) => value!.contains("@") ? null : "Email Inválido",
                  onChanged: (value) => setState(() {_email = value;}),
                  decoration: InputDecoration(labelText: "Digite seu email...", border: OutlineInputBorder()),
                ),
                SizedBox(height: 10,),
                //campo senha
                TextFormField(
                  validator:(value) => value!.length >= 6 ? null : "A senha deve conter no mínimo 6 caracteres",
                  onChanged: (value) => setState(() => _senha = value,),
                  decoration: InputDecoration(labelText: "Digite sua senha...", 
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    // Toda a vez que eu apertar o botãa inverte o valor da booleana (o ! faz isso)
                    onPressed: ()=>setState(()=> _senhaOculta = ! _senhaOculta), 
                    icon: Icon(_senhaOculta ? Icons.visibility : Icons.visibility_off))),
                  obscureText: _senhaOculta,
                  //mecanismo para mostrar senha oculta
                ),
                SizedBox(height: 10,),
                // Confirmação de senha 
                TextFormField(
                    validator: (value) => value! == _senha ? null: "A senha deve ser igual a anterior",
                    onChanged: (value) => setState(() => _confirmarSenha = value,),
                    decoration: InputDecoration(labelText: "Digite sua senha novamente...", 
                    border: OutlineInputBorder())
                ),

                SizedBox(height: 10,),
                // Row(children: [
                //   Text("Sexo:"),
                //   SizedBox(width: 10,),
                //   Radio(
                //     value: "Feminino",
                //     groupValue: _sexo,
                //     onChanged: (value)=> setState(() { _sexo = value!;}),
                //   ),
                //   Text("Feminino"),
                //   SizedBox(width: 10,),
                //   Radio(
                //     value: "Masculimo",
                //     groupValue: _sexo,
                //     onChanged: (value)=> setState(() { _sexo = value!;}),
                //   ),
                //   Text("Masculino"),
                //    SizedBox(width: 10,),
                //   Radio(value: "Outro",
                //   groupValue: _sexo,
                //   onChanged: (value) => setState(() {_sexo = value!;}),
                //   ),
                //   Text("Outro"),
                // ],)

                // Forma moderna de fazer o radio button usando o RadioGroup 
                RadioGroup<String>(
                  groupValue: _sexo,
                  onChanged: (String? value)=> setState(() {
                    _sexo = value!;
                  }), 
                  child: Row(
                    children: [
                      Radio(value: "Feminino"),
                      Text("Feminino"),
                      SizedBox(width: 10,),
                      Radio(value: "Masculino"),
                      Text("Masculino"),
                      SizedBox(width: 10,),
                      Radio(value: "Outro"),
                      Text("Outro"),
                      SizedBox(width: 5,)
                    ],
                  )),

                // Slider para Selecionar a Idade
                SizedBox(height: 10,),
                Row(
                    children: [
                      Text("Idade: ${_idade.toInt()}"), //exibir a idade selecionada
                      Expanded(child: Slider(
                        value: _idade, 
                        onChanged: (value)=> setState(() {
                          _idade = value;
                        }),
                        min: 0,
                        max: 100,
                        divisions:100,
                        label: _idade.toInt().toString(),))
                    ],
                ),
               // CheckBox para selecionar interesses
                  SizedBox(height: 10,),
                  Column(children: [
                    Text("Interesses Pessoais:"),
                    Row(
                      children: [
                        Checkbox(
                          value: _interesses.contains("Cinema"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Cinema") : _interesses.remove("Cinema");
                          })),
                        Text("Cinema"),
                        SizedBox(width: 5,),
                        Checkbox(
                          value: _interesses.contains("Teatro"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Teatro") : _interesses.remove("Teatro");
                          })),
                        Text("Teatro"),
                        SizedBox(width: 5,),
                        Checkbox(
                          value: _interesses.contains("RPG"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("RPG") : _interesses.remove("RPG");
                          })),
                        Text("RPG"),
                        SizedBox(width: 5,),
                        // wrap para quebrar linhas  
                      ],),
                      SizedBox(height: 10,),
                      Row(
                      children: [
                        Checkbox(
                          value: _interesses.contains("Esporte"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Esporte") : _interesses.remove("Esporte");
                          })),
                        Text("Esporte"),
                        SizedBox(width: 5,),
                        Checkbox(
                          value: _interesses.contains("Música"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Música") : _interesses.remove("Música");
                          })),
                        Text("Música"),
                        SizedBox(width: 5,),
                        Checkbox(
                          value: _interesses.contains("Viagem"), 
                          onChanged: (bool? value) => setState(() {
                            value! ? _interesses.add("Viagem") : _interesses.remove("Viagem");
                          })),
                        Text("Viagem"),
                        SizedBox(width: 5,),
                        // wrap para quebrar linhas  
                      ],),
                  ],),
                  // Dropdow para selecionar a cidade 
                  SizedBox(height: 20,),
                  Text("Cidade:"),
                  SizedBox(height: 10,),
                  DropdownButtonFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items: [
                    DropdownMenuItem(value: "Americana", child: Text("Americana"),),
                    DropdownMenuItem(value: "Nova Odessa", child: Text("Nova "),),
                    DropdownMenuItem(value: "Sumaré", child: Text("Sumaré"),),
                    DropdownMenuItem(value: "Campinas", child: Text("Campinas"),),
                    DropdownMenuItem(value: "Santa Bárbara d'Oeste", child: Text("Santa Bárbara d'Oeste"),),
                    DropdownMenuItem(value: "Outra", child: Text("Outra"),),

                    ], 
                    onChanged: (String? value) => setState(() {
                      _cidade = value!;
                    })),
                  SizedBox(height: 20,),
                  // Switch para aceitar os termos de uso
                  Row(children: [
                    Switch(
                      value: _aceitarTermos, 
                      onChanged: (bool value) => setState(() {
                        _aceitarTermos = value;
                      })),
                    Text("Aceitar os Termos de Uso")
                  ],),

                  // Botçao de envio do formulário 
                  ElevatedButton(
                    onPressed: () => _enviarFormulario(),
                    child: Text("Enviar Formulário"),
                  )
                ]) ,
          )),),
    );
  }
  void _enviarFormulario(){
    // Verificação do formulário
    // Mostrar os dados em dialog
    if (formKey.currentState!.validate()){
      if (_aceitarTermos) {
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text("Dados do Formulário"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Nome: $_nome"),
                Text("Email: $_email"),
                Text("Senha: $_senha"),
                Text("Sexo: $_sexo"),
                Text("Idade: ${_idade.toInt()}"),
                Text("Interesses: ${_interesses.join(", ")}"),
                Text("Cidade: $_cidade"),
              ],
            ),
          ),
          actions: [
           ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                //limpar formulário
                setState(() {
                  _nome = "";
                  _email = "";
                  _senha = "";
                  _confirmarSenha = "";
                  _sexo = "Feminino";
                  _idade = 18;
                  _interesses = [];
                  _cidade = "Americana";
                  _aceitarTermos = false;
                  formKey.currentState!.reset(); //reseta a validação do formulário
                });
              },//volta para a tela anterior(home) 
              child: Text("Ok")),
          ],  
        ));
      }else{

      }
    }

  }
}