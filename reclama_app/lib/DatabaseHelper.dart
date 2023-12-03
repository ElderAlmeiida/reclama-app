import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'your_database.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      print('Erro durante a inicialização do banco de dados: $e');
      rethrow; // Rethrow para que o erro seja visível no console
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertCadastro(Map<String, dynamic> cadastro) async {
    final db = await database;
    await db.insert('usuario', cadastro,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getCadastroPorEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuario',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
  }
}
