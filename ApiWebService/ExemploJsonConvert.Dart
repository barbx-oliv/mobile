//Exemplo de uso do Convert Json

//importar a biblioteca

import 'dart:convert'; // biblioteca nativa do datr não precisa usar pub add

void main(List<String> args) {
  //declarando uma string em formato de coleção
  String dbJson = '''{
    "id":1,
    "nome":"João",
    "login":"joao_user",
    "status":true,
    "senha":"1234",
    "endereço":{"Rua":"A","numero":234},
    "emails":["joao@email.com","joao2@email.com"]
  }''';

  //converter o Texto Json => Map Dart
  Map<String, dynamic> usuario =json.decode(dbJson);

  print(usuario["nome"]);//printando informação da chave nome
  print(usuario["login"]);//printando informação da chave login


  //mudando um valor
  usuario["senha"]="1111";

  //converter o MAP em Texto Json usando encode
  String dbJson2 = json.encode(usuario);

  //printando o texto Json
  print(dbJson2);   

}

