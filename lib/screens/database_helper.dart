import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
import './perguntas/fase_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;
  static final Logger _logger = Logger('DatabaseHelper');

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_app.db');
    _logger.info("Banco de dados iniciado em: $path");
    return await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE fases (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nome TEXT 
          )
        ''');
        await db.execute(''' 
          CREATE TABLE perguntas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fase_id INTEGER,
            texto TEXT,
            tema TEXT,
            FOREIGN KEY(fase_id) REFERENCES fases(id)
          )
        ''');
        await db.execute(''' 
          CREATE TABLE progresso (
            id INTEGER PRIMARY KEY,
            fase_atual INTEGER,
            pergunta_atual INTEGER,
            pontuacao INTEGER DEFAULT 0
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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            ALTER TABLE progresso ADD COLUMN pontuacao INTEGER DEFAULT 0
          ''');
        }
      },
    );
  }

  Future<void> inserirFases(List<Fase> fases) async {
    final db = await database;

    for (var fase in fases) {
      int faseId = await db.insert(
        'fases',
        {'nome': fase.nome},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var pergunta in fase.perguntas) {
        print("Inserindo pergunta: ${pergunta.texto}, Tema: ${pergunta.tema}");
        await db.insert(
          'perguntas',
          {
            'fase_id': faseId,
            'texto': pergunta.texto,
            'tema': pergunta.tema,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<List<Fase>> obterFases() async {
    final db = await database;
    List<Fase> fases = [];

    var faseResults = await db.query('fases');
    for (var faseData in faseResults) {
      int faseId = faseData['id'] as int;
      String nome = faseData['nome'] as String;

      var perguntaResults = await db.query(
        'perguntas',
        where: 'fase_id = ?',
        whereArgs: [faseId],
      );

      List<Pergunta> perguntas = perguntaResults.map((perguntaData) {
        print("Obtendo pergunta: ${perguntaData['texto']}, Tema: ${perguntaData['tema']}");
        return Pergunta(
          id: perguntaData['id'] as int,
          texto: perguntaData['texto'] as String,
          tema: perguntaData['tema'] as String,
          respostas: [],
        );
      }).toList();

      fases.add(Fase(id: faseId, nome: nome, perguntas: perguntas));
    }

    return fases;
  }

  Future<void> salvarProgresso(int fase, int pergunta, int pontuacao) async {
    final db = await database;
    print("Salvando progresso: Fase $fase, Pergunta $pergunta, Pontuação $pontuacao");

    var resultado = await db.query(
      'progresso',
      where: 'id = ?',
      whereArgs: [1], // ID fixo (você pode usar um campo de usuário aqui se necessário)
    );

    if (resultado.isEmpty) {
      await db.insert(
        'progresso',
        {'fase_atual': fase, 'pergunta_atual': pergunta - 1, 'pontuacao': pontuacao},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        'progresso',
        {'fase_atual': fase, 'pergunta_atual': pergunta - 1, 'pontuacao': pontuacao},
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<Map<String, dynamic>?> carregarProgresso() async {
    final db = await database;
    final result = await db.query('progresso', limit: 1);
    print("Progresso carregado: $result");

    if (result.isNotEmpty) {
      return result.first; // Retorna o primeiro (único) progresso
    }
    return null; // Retorna null se não houver progresso salvo
  }

  Future<void> salvarConquista(String conquista, String tema) async {
    final db = await database;
    print("Salvando conquista: $conquista, Tema: $tema");
    await db.insert(
      'conquistas',
      {'conquista': conquista, 'tema': tema},
    );
  }

  Future<List<Map<String, dynamic>>> carregarConquistas() async {
    final db = await database;
    final result = await db.query('conquistas');
    print("Carregando conquistas: $result");
    return result;
  }

  Future<void> atualizarProgressoTema(String tema) async {
    final db = await database;
    var resultado =
        await db.query('progresso_tema', where: 'tema = ?', whereArgs: [tema]);
    print("Resultado ao atualizar progresso por tema: $resultado");
    if (resultado.isEmpty) {
      await db.insert('progresso_tema', {'tema': tema, 'acertos': 1});
    } else {
      int acertos = resultado.first['acertos'] as int;
      await db.update(
        'progresso_tema',
        {'acertos': acertos + 1},
        where: 'tema = ?',
        whereArgs: [tema],
      );
    }
  }

  Future<int> obterProgressoTema(String tema) async {
    final db = await database;
    var resultado =
        await db.query('progresso_tema', where: 'tema = ?', whereArgs: [tema]);
    print("Progresso obtido para o tema '$tema': $resultado");
    return resultado.isNotEmpty ? resultado.first['acertos'] as int : 0;
  }
}
