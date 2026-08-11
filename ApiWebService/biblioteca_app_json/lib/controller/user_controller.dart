import '../model/user_model.dart';
import '../service/api_service.dart';

class UserController {
  // Nn precisa instanciar obj de service -> Static 

  // Métodos
  // Ler 
  Future<List<UserModel>> fetchAll() async {
    final list = await ApiService.getList("users?_sort=name"); // ?sort=name -> flag para organizar em ordem alfabetica por nome
    // retorna a lista de usuário convertidos para UserModel 
    return list.map<UserModel>((item) => UserModel.fromMap(item)).toList();
  }

  // Criar 
  Future<UserModel> create(UserModel u) async {
    final created = await ApiService.post("user", u.toMap());
    // Adiciona um usuário e retorna o UsuárioCriado => ID
    return UserModel.fromMap(created);
  }

  // Atualizar 
  Future<UserModel> update(UserModel u) async {
    final update = await ApiService.put("users", u.toMap(), u.id!);
    // Envia a atualização do usuário e retorna o usuário atualizado do banco 
    return UserModel.fromMap(update);
  }

  // Deletar 
  Future<void> delete(String id) async {
    await ApiService.delete("user", id); // Se esse metodo nn der certo, ele irá gerar uma exceptiom
  }
}