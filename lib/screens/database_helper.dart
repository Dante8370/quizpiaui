import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_app.db');
    print("Banco de dados iniciado em: $path"); // Log
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE progresso (
            id INTEGER PRIMARY KEY,
            fase_atual INTEGER,
            pergunta_atual INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE conquistas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conquista TEXT,
            tema TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE progresso_tema (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tema TEXT,
            acertos INTEGER
          )
        ''');
      },
    );
  }

  Future<void> salvarProgresso(int fase, int pergunta) async {
    final db = await database;
    print("Salvando progresso: Fase $fase, Pergunta $pergunta"); // Log
    await db.insert(
      'progresso',
      {'fase_atual': fase, 'pergunta_atual': pergunta},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> carregarProgresso() async {
    final db = await database;
    final result = await db.query('progresso', limit: 1);
    print("Progresso carregado: $result"); // Log
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> salvarConquista(String conquista, String tema) async {
    final db = await database;
    print("Salvando conquista: $conquista, Tema: $tema"); // Log
    await db.insert(
      'conquistas',
      {'conquista': conquista, 'tema': tema},
    );
  }

  Future<List<Map<String, dynamic>>> carregarConquistas() async {
    final db = await database;
    final conquistas = await db.query('conquistas');
    print("Conquistas carregadas: $conquistas"); // Log
    return conquistas;
  }

  Future<void> atualizarProgressoTema(String tema) async {
    final db = await database;
    final result = await db.query(
      'progresso_tema',
      where: 'tema = ?',
      whereArgs: [tema],
    );

    if (result.isNotEmpty) {
      int acertos = result.first['acertos'] as int;
      await db.update(
        'progresso_tema',
        {'acertos': acertos + 1},
        where: 'tema = ?',
        whereArgs: [tema],
      );
    } else {
      await db.insert(
        'progresso_tema',
        {'tema': tema, 'acertos': 1},
      );
    }
    print("Progresso do tema $tema atualizado"); // Log
  }

  Future<int> obterProgressoTema(String tema) async {
    final db = await database;
    final result = await db.query(
      'progresso_tema',
      where: 'tema = ?',
      whereArgs: [tema],
    );

    if (result.isNotEmpty) {
      return result.first['acertos'] as int;
    }
    return 0;
  }
}

