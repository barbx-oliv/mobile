class UserModel{
  // Atributos
  final String? id;
  final String name;

  // Construtor 
  UserModel({this. id, required this.name});

  // Métodos 
  // toMap => OBJ MAP 
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };

  // FromMap => processo contrário do tomap
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map["id"].toString(),
    name: map["name"].toString(), 
  );
}