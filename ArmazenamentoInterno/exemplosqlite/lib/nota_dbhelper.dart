import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exemplosqlite/nota_model.dart';


// Ajudante de conexão com o dataBase(DB)  
class NotaDbhelper {
  // Atributos
  static const String db_nome = "notas.db";
  static const String table_nome = "notas";
  static const String create_table = """
    CREATE TABLE IF NOT EXISTS $table_nome(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      conteudo TEXT NOT NULL
    )"""; 

    // Método de conexão 
    // Método do tipo future (Async)
    Future<Database> _getDB() async{
      return openDatabase(
        // o Join junta o local + o banco - colocar o endereço do BD (banco de dados)
        join(await getDatabasesPath(), db_nome),
        onCreate: (db, version) { // Se é a primeira vez que está sendo executado, ele ira criar o BD
          return db.execute(create_table);
        },
        version: 1, 
      ); 
    } // Retorna o BD no final 

    // CRUD do BD (Seria o Controller)

    // Create 
  void create(Nota nota) async{
    try {
      final Database db = await _getDB();
      await db.insert(table_nome, nota.toMap());
    } catch (e) {
      print(e); 
        return;
      }
  }

  // Read
  Future<List<Nota>> getNotas() async{
    try {
      final Database db = await _getDB(); // estabelece a conexão
      final List<Map<String,dynamic>> maps = await db.query(table_nome); //pega todos os dados do banco
      //converter o MAP em List<Nota>
      return List.generate(maps.length, (e) => Nota.fromMap(maps[e])); //retrona a lista com os OBJ
    } catch (e) {
      print(e); //mostre o erro
      return []; //retorna uma lista vazia
    }
  }

  // Update 
  void updateNota(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.update(table_nome, nota.toMap(), where: "id = ?", whereArgs: [nota.id]); 
      // Atualiza a nota a partir do ID 
    } catch (e) {
      print(e);
      return;
    }
  }

  // Delete
  void deleteNota(int id) async {
    try {
      final Database db = await _getDB();
      await db.delete(table_nome, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return;
    }
  }
}