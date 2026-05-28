import 'package:sa_formativa_petshop_sqlite/service/database_helper.dart';
import 'package:sa_formativa_petshop_sqlite/model/pet_model.dart';

class PetController {
  // atributo para estabelecer conexão com o banco 
  final _dbHelper = DatabaseHelper();

  // Métodos dos controller

  Future<int> salvarPet(Pet pet) async => _dbHelper.insertPet(pet);

  //Listar todos os pets
  Future<List<Pet>> listarTodos() async => _dbHelper.getPets();

}