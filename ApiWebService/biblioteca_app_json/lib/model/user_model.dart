class UserModel {
    // Atributos
    final String? id;
    final String name;
    final String email;

    // Construtor 
    UserModel({this.id, required this.name, required this.email});

    // Métodos 
    // toMap => OBJ => MAP 
    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email
    };

    // From map (processo contrário do toMap) => MAP -> OBJ
    factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map["id"].toString(),
        name: map["name"].toString(),
        email: map["email"].toString(),
    );
}