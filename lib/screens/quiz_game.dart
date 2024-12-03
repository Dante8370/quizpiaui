import 'package:flutter/material.dart';
import './perguntas/fase_model.dart'; 
import 'database_helper.dart'; 

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
    print("Carregando progresso: $progresso"); // Log
    if (progresso != null) {
      setState(() {
        faseAtual = progresso['fase_atual']; 
        perguntaAtual = progresso['pergunta_atual'] ?? 0; // Garantir que começa da primeira pergunta
      });
    } else {
      // Se o progresso for nulo, iniciamos do começo
      setState(() {
        faseAtual = 0;
        perguntaAtual = 0;
      });
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
    print("Respondendo pergunta. Correto: $isCorrect, Tema: $tema"); // Log
    if (isCorrect) {
      setState(() {
        score += 10; 
      });
      await DatabaseHelper().atualizarProgressoTema(tema);
      int acertos = await DatabaseHelper().obterProgressoTema(tema);
      print("Acertos no tema $tema: $acertos"); // Log

      if (acertos == 3) {
        String conquista = 'Historiador Iniciante em $tema';
        _adicionarConquista(conquista, tema);
      } else if (acertos == 5) {
        String conquista = 'Historiador Veterano em $tema';
        _adicionarConquista(conquista, tema);
      }
    }

    if (perguntaAtual < fases[faseAtual].perguntas.length - 1) {
      setState(() {
        perguntaAtual++;
      });
    } else {
      if (faseAtual < fases.length - 1) {
        _showParabensDialog();
      } else {
        _showFinalScoreDialog();
      }
    }

    await DatabaseHelper().salvarProgresso(faseAtual, perguntaAtual);
    print("Progresso salvo: Fase $faseAtual, Pergunta $perguntaAtual"); // Log
  }

  void _adicionarConquista(String conquista, String tema) async {
    print("Adicionando conquista: $conquista, Tema: $tema"); // Log
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
