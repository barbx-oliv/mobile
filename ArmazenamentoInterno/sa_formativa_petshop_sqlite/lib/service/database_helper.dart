import 'package:path/path.dart';
import 'package:sa_formativa_petshop_sqlite/model/consulta_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_formativa_petshop_sqlite/model/pet_model.dart';

class DatabaseHelper {
  // classe do tipo singleton (permite o instanciamento de um unico obj por vez)

  static final DatabaseHelper _instance = DatabaseHelper._internal(); // instance é o DB interno, o instance só vai existir se o interno existir

  //essa não possui um construtor normal 
  //ele precisa do factory para estabelecer a conexão com o banco de dados
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Com essa técnica de escrita de construtor, a classe permite a criação de apenas um obj por vez

  // Conector do BD 
  Database? _database; // privado

  // Método do BD 
  Future<Database> get database async{
    if (_database != null) return _database!; // Se a conexão já existir, retorna a conexão existente
    _database = await _initDb(); // Se não existir, inicia uma nova
    return _database!;
  }

  Future<Database> _initDb() async{
    // Começar a conexão com o banco
  String path = join(await getDatabasesPath(), "petshop_db");
  return await openDatabase(
    path,
    version: 1,
    // A primeira vez que ele for rodar o banco, cria as tabelas)
    onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE pets(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome TEXT, raca TEXT, 
          nomeDono TEXT, 
          telefoneDono TEXT)''');
        await db.execute(
          '''CREATE TABLE consultas(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          petId INTEGER, 
          tipoServico TEXT, 
          dataHora TEXT, 
          observacoes TEXT,
          FOREIGN KEY(petId) REFERENCES pets(id) ON DELETE CASCADE)''');
    },
    onConfigure: (db) async => await db.execute("PRAGMA foreign_key = ON")); // garante o delete on CASCATE
  }

  //métodos do APIREST Simplificados - É como se eu tivesse fazendo uma conexão com uma api 

  //inserir pet - POST
  Future<int> insertPet(Pet pet) async => (await database).insert("pets", pet.toMap());

  //Listar Pets do DB - GET
  Future<List<Pet>> getPets() async {
    //busca os pets no banco e retrona uma lista em ordem alfabetica
    final List<Map<String, dynamic>> maps = await (await database).query("pets", orderBy: "nome ASC");
    return List.generate(maps.length, (e) => Pet.fromMap(maps[e]));
  }

  // Inserir consulta - POST
  Future<int> insertConsulta(Consulta c) async => (await database).insert("consultas", c.toMap());

  // Get consulta por Pet - GET
  Future<List<Consulta>> getConsultaPorPet(int petId) async {
    final List<Map<String, dynamic>> maps = await (await database).query("consultas", where: "petId = ?", whereArgs: [petId], orderBy: "dataHora DESC");
    return List.generate(maps.length, (e)=> Consulta.fromMap(maps[e]));
  }
}
