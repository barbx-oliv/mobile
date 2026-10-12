import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:api_cine/model/movie_model.dart';

class FavoritesController {
  static Database? _database;

  // Inicializa o Banco de Dados SQLite
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  // Adicionar filme aos favoritos
  Future<void> addFavorite(Movie movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Pegar lista de favoritos
  Future<List<Movie>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((map) => Movie.fromMap(map)).toList();
  }

  // Remover favorito por ID
  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}