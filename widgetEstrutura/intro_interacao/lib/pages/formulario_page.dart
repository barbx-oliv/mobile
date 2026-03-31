// Tela com Elementos de Formulário para Interação do Usuário
// textField -> Entrada de Dados
// Checkbox -> Seleção de Opções
// Radio Button -> Uma Única Opção
// Slider -> Barra de Seleção 
// Switch -> Botão de Alternância 
// DropDown -> Menu Suspenso 

import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget{
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  //atributos 
  //(nome, email, senha, validação de senha, termos de uso(switch), sexo(radio), idade(slider), interesses(chech) )
  String _nome = "";
  String _email = "";
  String _senha = "";
  String _confirmarSenha = "";
  bool _aceitarTermos = false;
  String _sexo = "Feminino";
  double _idade = 18;
  List<String> _interesses = [];
  String _cidade = "Americana";

  // Chave Global de Validação do Formuláro 
  formKey = GlobalKey<FormState>(); // Formulário somente será enviado se a chave estiver validada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de Cadastro"),),
      body: Padding(
        // Espaçamento Geral em 8px em Toda a Tela
        padding: EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo do Nome 
                TextFormField(
                  // Validação do Campo
                  validator: (value) => value!.isEmpty ? ,
                )
              ],
            ),
          )),)
    );
  }
}