// Modelagem de dados 

class Nota {
  // Atributos
  final int? id; // Permito que a variável seja nula 
  // Em um primeiro momento a variável é nula 
  // somente quando cair no DB ira receber um valor para o ID
  final String titulo;
  final String conteudo;

  // Construtor 
  Nota({this.id, required this.titulo, required this.conteudo});

  // Métodos de serialização de dados (ToMap() e o fromMap())

  // toMap() => converter um obj da Classe Nota para Map de DB (inserir dados no DB)
  Map<String, dynamic> toMap(){ // O map é uma lista não ordenada, os itens são mapeados por chave Ex. Chave - SP valor São Paulo
    return{
      "id": id, // Mapenado as colunas do DB com os atributos da Classe
      "titulo": titulo,
      "conteudo": conteudo
    };
  }

  // Converter um MAP(vindo do DB) == Obj da Classe  Nota
  // Para fazer o from vamos usar um factory -> fabricar um objeto 
  factory Nota.fromMap(Map<String,dynamic> map) { // Fabricando apartir de um map 
    return Nota(
      id: map["id"] as int, // Se esta voltando do DB, então já tem um ID
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String
    );
  }

  // Método para imprimir dados
  @override
  String toString() {
    return "Nota{id: $id, título: $titulo, conteúdo: $conteudo}";
  }
}