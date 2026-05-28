class Pet{
  //atributos
  int? id; //pode ser nulo inicialmente => quem irá atribuir o Id é o BD
  String nome;
  String raca;
  String nomeDono;
  String telefone;

  //construtor
  Pet({this.id, required this.nome, required this.raca, required this.nomeDono, required this.telefone});

  //Mapaeamento de Dados
  //toMap
  Map<String,dynamic> toMap() => {
    "id":id,
    "nome":nome,
    "raca":raca,
    "nomeDono":nomeDono,
    "telefone":telefone
  };

  //fromMap
  factory Pet.fromMap(Map<String, dynamic> map)=>Pet(
    id: map["id"],
    nome: map["nome"], 
    raca: map["raca"], 
    nomeDono: map["nomeDono"], 
    telefone: map["telefone"]);
}