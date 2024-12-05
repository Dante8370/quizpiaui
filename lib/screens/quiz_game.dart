import 'package:flutter/material.dart';
import './perguntas/fase_model.dart'; 
import 'database_helper.dart'; 
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizScreen');


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key}); 

  @override
  QuizScreenState createState() => QuizScreenState(); 
}

class QuizScreenState extends State<QuizScreen> {
  int score = 0; 
  int faseAtual = 0; 
  int perguntaAtual = 0; 
  List<String> conquistas = []; 
  final List<Fase> fases = obterFases(); 

  @override
  void initState() {
    super.initState();
    _carregarProgresso(); 
    _carregarConquistas(); 
  }

  void _carregarProgresso() async {
    var progresso = await DatabaseHelper().carregarProgresso();
    _logger.info("Carregando progresso: $progresso");
    if (progresso != null) {
      setState(() {
        faseAtual = progresso['fase_atual'];
        perguntaAtual = progresso['pergunta_atual'] ?? 0;
        score = progresso['pontuacao'] ?? 0;  // Carregar a pontuação
      });
      _logger.info("Progresso carregado: Fase $faseAtual, Pergunta $perguntaAtual, Pontuação $score");
    } else {
      setState(() {
        faseAtual = 0;
        perguntaAtual = 0;
        score = 0; // Inicializa a pontuação
      });
      _logger.info("Progresso não encontrado, iniciando do começo");
    }
  }




  void _carregarConquistas() async {
    var conquistas = await DatabaseHelper().carregarConquistas();
    print("Conquistas carregadas: $conquistas"); // Log
    setState(() {
      this.conquistas = conquistas.map((item) => item['conquista'] as String).toList(); 
    });
  }


void responderPergunta(bool isCorrect, String tema) async {
  if (isCorrect) {
    setState(() {
      score += 10; // Incrementa pontuação
    });

    // Atualizar progresso no tema
    await DatabaseHelper().atualizarProgressoTema(tema);
    int acertos = await DatabaseHelper().obterProgressoTema(tema);

    // Criar conquistas com base no tema
    if (acertos == 3) {
      String conquista = 'Explorador Iniciante em $tema';
      _adicionarConquista(conquista, tema);
    } else if (acertos == 5) {
      String conquista = 'Especialista em $tema';
      _adicionarConquista(conquista, tema);
    } else if (acertos == 10) {
      String conquista = 'Mestre do Conhecimento em $tema';
      _adicionarConquista(conquista, tema);
    }
  }

  // Passa para a próxima pergunta ou fase
  if (perguntaAtual < fases[faseAtual].perguntas.length - 1) {
    setState(() {
      perguntaAtual++;
    });
  } else if (faseAtual < fases.length - 1) {
    _showParabensDialog();
    setState(() {
      faseAtual++;
      perguntaAtual = 0;
    });
  } else {
    _showFinalScoreDialog();
  }

  // Salva o progresso
  await DatabaseHelper().salvarProgresso(faseAtual, perguntaAtual, score);
}



  void _adicionarConquista(String conquista, String tema) async {
    _logger.info("Adicionando conquista: $conquista, Tema: $tema"); // Log
    setState(() {
      conquistas.add(conquista); 
    });
    await DatabaseHelper().salvarConquista(conquista, tema);
  }


  void _showParabensDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Parabéns!'),
      content: const Text('Você completou esta fase!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
            setState(() {
              faseAtual++; 
              perguntaAtual = 0;
            });
          },
          child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }


  void _showFinalScoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fim do Quiz!'),
        content: Text('Sua pontuação final é: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fase = fases[faseAtual]; 
    final pergunta = fase.perguntas[perguntaAtual]; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz do Piauí'),
        centerTitle: true,
        backgroundColor: Colors.green[800], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              fase.nome,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), 
            Text(
              pergunta.texto,
              style: TextStyle(fontSize: 24, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), 
            ...pergunta.respostas.map((resposta) => _botaoResposta(
              resposta['text'] as String, 
              resposta['isCorrect'] as bool, 
              fase.nome, 
            )),
            const Spacer(), 
            Text(
              'Pontuação: $score',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoResposta(String texto, bool isCorrect, String tema) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => responderPergunta(isCorrect, tema),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[800], 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
          padding: const EdgeInsets.symmetric(vertical: 16), 
        ),
        child: Text(
          texto, 
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
