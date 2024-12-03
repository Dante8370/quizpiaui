import 'package:flutter/material.dart';
import './perguntas/fase_model.dart'; // Importa o arquivo de fases
import './conquistas_screen.dart'; // Importa a tela de conquistas
import 'database_helper.dart'; // Importa a classe do banco de dados

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int score = 0;
  int faseAtual = 0;
  int perguntaAtual = 0;

  // Lista para armazenar as conquistas
  List<String> conquistas = [];

  // Carrega as fases através da função do modelo
  final List<Fase> fases = obterFases();

  @override
  void initState() {
    super.initState();
    // Carregar progresso e conquistas
    _carregarProgresso();
    _carregarConquistas();
  }

  // Método para carregar o progresso de fase
  void _carregarProgresso() async {
    var progresso = await DatabaseHelper().carregarProgresso();
    if (progresso != null) {
      setState(() {
        faseAtual = progresso['fase_atual'];
        perguntaAtual = progresso['pergunta_atual'];
      });
    }
  }

  // Método para carregar as conquistas
  void _carregarConquistas() async {
    var conquistas = await DatabaseHelper().carregarConquistas();
    setState(() {
      this.conquistas = conquistas.map((item) => item['conquista'] as String).toList();
    });
  }

  void responderPergunta(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        score += 10;
      });
    }
    if (perguntaAtual < fases[faseAtual].perguntas.length - 1) {
      setState(() {
        perguntaAtual++;
      });
    } else {
      if (faseAtual < fases.length - 1) {
        // Ao passar de fase, mostra a tela de parabéns e grava a conquista
        _showParabensDialog();
      } else {
        _showFinalScoreDialog();
      }
    }
  }

  void _showParabensDialog() {
    // Exibe o dialog de parabéns
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Parabéns!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Você passou de fase! Agora você está na fase ${faseAtual + 2}.', style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(fontSize: 16)),
            onPressed: () {
              setState(() {
                faseAtual++;
                perguntaAtual = 0;
                conquistas.add('Passou para a fase ${faseAtual + 1}'); // Adiciona conquista
                // Salva a conquista no banco de dados
                DatabaseHelper().salvarConquista('Passou para a fase ${faseAtual + 1}', faseAtual + 1);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showFinalScoreDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fim do Quiz!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Sua pontuação final foi: $score', style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            child: const Text('Recomeçar', style: TextStyle(fontSize: 16)),
            onPressed: () {
              setState(() {
                score = 0;
                faseAtual = 0;
                perguntaAtual = 0;
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Ver Conquistas', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaConquistas(conquistas: conquistas),
                ),
              );
            },
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
        title: const Text('Quiz do Piauí', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.lightGreen[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              fase.nome, // Exibe o nome da fase
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              pergunta.texto,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...pergunta.respostas.map((resposta) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => responderPergunta(resposta['isCorrect'] as bool),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800], // Cor do botão
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fixedSize: const Size(300, 60), // Largura = 300, Altura = 60
                    ),
                    child: Text(
                      resposta['text'] as String,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10), // Espaçamento de 10 pixels entre os botões
                ],
              );
            }),
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
}
