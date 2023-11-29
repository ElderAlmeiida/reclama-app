import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;
  
  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

      Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'your_database.db');
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);
      return _database;
    } catch (e) {
      print('Erro durante a inicialização do banco de dados: $e');
      rethrow;  // Rethrow para que o erro seja visível no console
    }
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id_usuario INTEGER PRIMARY KEY,
        nome_usuario TEXT NOT NULL,
        email_usuario TEXT NOT NULL,
        senha_usuario TEXT NOT NULL,
        minhas_reclamacoes_usuario TEXT,
        comentarios TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reclamacao (
        id_reclamacao INTEGER PRIMARY KEY,
        data_reclamacao TEXT NOT NULL,
        tipo_reclamacao TEXT NOT NULL,
        descricao_reclamacao TEXT NOT NULL,
        status_reclamacao TEXT NOT NULL,
        id_usuario INTEGER,
        comentario_reclamacao TEXT NOT NULL,
        localizacao_reclamacao TEXT NOT NULL,
        prioridade_reclamacao TEXT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    await db.insert('usuario', usuario);
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await database;
    return await db.query('usuario');
  }

  Future<void> insertReclamacao(Map<String, dynamic> reclamacao) async {
    final db = await database;
    await db.insert('reclamacao', reclamacao);
  }

  Future<List<Map<String, dynamic>>> getReclamacoes() async {
    final db = await database;
    return await db.query('reclamacao');
  }
    DatabaseHelper() {
    _initDatabase();
  }
}
