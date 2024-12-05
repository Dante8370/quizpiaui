import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
import './perguntas/fase_model.dart';

class DatabaseHelper {
  // Singleton: garante que apenas uma instância de DatabaseHelper será criada
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Construtor privado para impedir a criação de instâncias adicionais
  DatabaseHelper._internal();

  // Instância do banco de dados
  static Database? _database;
  
  // Logger para registrar mensagens de depuração
  static final Logger _logger = Logger('DatabaseHelper');

  // Getter para acessar o banco de dados. Inicializa o banco caso ainda não esteja pronto
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados, definindo seu caminho e tabelas
  Future<Database> _initDatabase() async {
    // Obtém o caminho do banco de dados no dispositivo
    String path = join(await getDatabasesPath(), 'quiz_app.db');
    _logger.info("Banco de dados iniciado em: $path");

    // Abre o banco de dados e define os métodos onCreate e onUpgrade
    return await openDatabase(
      path,
      version: 2, // Versão atual do banco de dados
      onCreate: (db, version) async {
        // Criação das tabelas do banco
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
      // Atualiza o banco de dados se a versão mudar
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Adiciona a coluna 'pontuacao' na tabela progresso, se ainda não existir
          await db.execute('''
            ALTER TABLE progresso ADD COLUMN pontuacao INTEGER DEFAULT 0
          ''');
        }
      },
    );
  }

  // Insere fases e suas perguntas associadas no banco de dados
  Future<void> inserirFases(List<Fase> fases) async {
    final db = await database;

    for (var fase in fases) {
      // Insere uma fase e obtém seu ID
      int faseId = await db.insert(
        'fases',
        {'nome': fase.nome},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var pergunta in fase.perguntas) {
        // Insere as perguntas associadas a essa fase
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

  // Obtém todas as fases e suas perguntas associadas do banco de dados
  Future<List<Fase>> obterFases() async {
    final db = await database;
    List<Fase> fases = [];

    // Consulta as fases
    var faseResults = await db.query('fases');
    for (var faseData in faseResults) {
      int faseId = faseData['id'] as int;
      String nome = faseData['nome'] as String;

      // Consulta as perguntas associadas a cada fase
      var perguntaResults = await db.query(
        'perguntas',
        where: 'fase_id = ?',
        whereArgs: [faseId],
      );

      // Mapeia os resultados das perguntas para objetos Pergunta
      List<Pergunta> perguntas = perguntaResults.map((perguntaData) {
        return Pergunta(
          id: perguntaData['id'] as int,
          texto: perguntaData['texto'] as String,
          tema: perguntaData['tema'] as String,
          respostas: [], // Respostas não estão sendo carregadas aqui
        );
      }).toList();

      // Adiciona a fase e suas perguntas à lista de fases
      fases.add(Fase(id: faseId, nome: nome, perguntas: perguntas));
    }

    return fases;
  }

  // Salva o progresso atual no banco de dados
  Future<void> salvarProgresso(int fase, int pergunta, int pontuacao) async {
    final db = await database;

    // Verifica se já existe um progresso salvo
    var resultado = await db.query(
      'progresso',
      where: 'id = ?',
      whereArgs: [1], // ID fixo para identificar o progresso
    );

    if (resultado.isEmpty) {
      // Insere o progresso se não existir
      await db.insert(
        'progresso',
        {'fase_atual': fase, 'pergunta_atual': pergunta - 1, 'pontuacao': pontuacao},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Atualiza o progresso se já existir
      await db.update(
        'progresso',
        {'fase_atual': fase, 'pergunta_atual': pergunta - 1, 'pontuacao': pontuacao},
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  // Carrega o progresso salvo
  Future<Map<String, dynamic>?> carregarProgresso() async {
    final db = await database;
    final result = await db.query('progresso', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // Salva uma conquista no banco de dados
  Future<void> salvarConquista(String conquista, String tema) async {
    final db = await database;
    await db.insert(
      'conquistas',
      {'conquista': conquista, 'tema': tema},
    );
  }

  // Carrega todas as conquistas do banco de dados
  Future<List<Map<String, dynamic>>> carregarConquistas() async {
    final db = await database;
    return await db.query('conquistas');
  }

  // Atualiza o progresso de acertos para um tema específico
  Future<void> atualizarProgressoTema(String tema) async {
    final db = await database;
    var resultado = await db.query(
      'progresso_tema',
      where: 'tema = ?',
      whereArgs: [tema],
    );

    if (resultado.isEmpty) {
      // Insere um novo registro se o tema ainda não estiver no progresso
      await db.insert('progresso_tema', {'tema': tema, 'acertos': 1});
    } else {
      // Atualiza o número de acertos para o tema
      int acertos = resultado.first['acertos'] as int;
      await db.update(
        'progresso_tema',
        {'acertos': acertos + 1},
        where: 'tema = ?',
        whereArgs: [tema],
      );
    }
  }

  // Obtém o número de acertos para um tema específico
  Future<int> obterProgressoTema(String tema) async {
    final db = await database;
    var resultado = await db.query(
      'progresso_tema',
      where: 'tema = ?',
      whereArgs: [tema],
    );
    return resultado.isNotEmpty ? resultado.first['acertos'] as int : 0;
  }
}
