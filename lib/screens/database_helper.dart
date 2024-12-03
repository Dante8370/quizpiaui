import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Cria ou abre o banco de dados
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE conquistas(id INTEGER PRIMARY KEY, conquista TEXT, fase INTEGER)',
      );
    }, version: 1);
  }

  // Salva uma conquista no banco de dados
  Future<void> salvarConquista(String conquista, int fase) async {
    final db = await database;
    await db.insert(
      'conquistas',
      {'conquista': conquista, 'fase': fase},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Carrega as conquistas do banco de dados
  Future<List<Map<String, dynamic>>> carregarConquistas() async {
    final db = await database;
    return await db.query('conquistas');
  }

  // Salva o progresso de fase no banco de dados
  Future<void> salvarProgresso(int faseAtual, int perguntaAtual) async {
    final db = await database;
    await db.insert(
      'progresso',
      {'fase_atual': faseAtual, 'pergunta_atual': perguntaAtual},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Carrega o progresso de fase
  Future<Map<String, dynamic>?> carregarProgresso() async {
    final db = await database;
    var result = await db.query('progresso');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
