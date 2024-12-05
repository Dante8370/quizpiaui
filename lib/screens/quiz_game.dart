// Importa os pacotes necessários para construir a interface Flutter e lidar com o modelo de dados e banco de dados
import 'package:flutter/material.dart';
import './perguntas/fase_model.dart';
import 'database_helper.dart';

// Mapeia as cores dos botões com base no estado atual
Map<String, Color> buttonColors = {};

// Define a tela principal do quiz como um StatefulWidget, pois ela contém estados mutáveis
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

// Classe de estado para `QuizScreen`
class QuizScreenState extends State<QuizScreen> {
  int score = 0; // Pontuação do jogador
  int faseAtual = 0; // Fase atual do quiz
  int perguntaAtual = 0; // Pergunta atual dentro da fase
  List<String> conquistas = []; // Lista de conquistas obtidas pelo jogador
  final List<Fase> fases = obterFases(); // Obtém as fases do quiz
  bool isAnswered = false; // Indica se a pergunta atual já foi respondida

  @override
  void initState() {
    super.initState();
    _carregarProgresso(); // Carrega o progresso salvo do jogador ao inicializar
    _carregarConquistas(); // Carrega as conquistas salvas
  }

  // Função para carregar o progresso do jogador do banco de dados
  void _carregarProgresso() async {
    var progresso = await DatabaseHelper().carregarProgresso();
    if (progresso != null) {
      setState(() {
        faseAtual = progresso['fase_atual'];
        perguntaAtual = progresso['pergunta_atual'] ?? 0;
        score = progresso['pontuacao'] ?? 0;
      });
    } else {
      setState(() {
        faseAtual = 0;
        perguntaAtual = 0;
        score = 0;
      });
    }
  }

  // Função para carregar as conquistas do banco de dados
  void _carregarConquistas() async {
    var conquistas = await DatabaseHelper().carregarConquistas();
    setState(() {
      this.conquistas =
          conquistas.map((item) => item['conquista'] as String).toList();
    });
  }

  // Atualiza as cores dos botões com base se as respostas são corretas ou não
  void _atualizarCores() {
    final respostas = fases[faseAtual].perguntas[perguntaAtual].respostas;
    setState(() {
      buttonColors = {
        for (var resposta in respostas)
          resposta['text'] as String:
              resposta['isCorrect'] as bool ? Colors.green[800]! : Colors.red[800]!,
      };
    });
    debugPrint('Cores dos botões: $buttonColors');
  }

  // Lógica para responder a pergunta atual
  void responderPergunta(bool isCorrect, String tema, String texto) async {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
    });

    _atualizarCores(); // Atualiza as cores dos botões

    if (isCorrect) {
      setState(() {
        score += 10; // Incrementa a pontuação se a resposta estiver correta
      });

      // Atualiza o progresso por tema no banco de dados
      await DatabaseHelper().atualizarProgressoTema(tema);
      int acertos = await DatabaseHelper().obterProgressoTema(tema);

      // Verifica se o jogador desbloqueou novas conquistas
      if (acertos == 3) {
        _adicionarConquista('Explorador Iniciante em $tema', tema);
      } else if (acertos == 5) {
        _adicionarConquista('Especialista em $tema', tema);
      } else if (acertos == 10) {
        _adicionarConquista('Mestre do Conhecimento em $tema', tema);
      }
    }

    // Após um pequeno atraso, atualiza para a próxima pergunta ou fase
    Future.delayed(const Duration(seconds: 1), () {
      if (perguntaAtual < fases[faseAtual].perguntas.length - 1) {
        setState(() {
          perguntaAtual++;
          isAnswered = false;
          buttonColors.clear();
        });
      } else if (faseAtual < fases.length - 1) {
        _showDialog('Parabéns!', 'Você completou esta fase!', () {
          setState(() {
            faseAtual++;
            perguntaAtual = 0;
            isAnswered = false;
            buttonColors.clear();
          });
        });
      } else {
        _showDialog('Fim do Quiz!', 'Sua pontuação final é: $score', () {
          Navigator.pop(context); // Retorna à tela anterior
        });
      }
      DatabaseHelper().salvarProgresso(faseAtual, perguntaAtual, score); // Salva o progresso
    });
  }

  // Adiciona uma nova conquista ao jogador
  void _adicionarConquista(String conquista, String tema) async {
    setState(() {
      conquistas.add(conquista);
    });
    await DatabaseHelper().salvarConquista(conquista, tema);
  }

  // Mostra um diálogo com título, conteúdo e ação ao continuar
  void _showDialog(String title, String content, VoidCallback onContinue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onContinue();
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fase = fases[faseAtual]; // Obtém a fase atual
    final pergunta = fase.perguntas[perguntaAtual]; // Obtém a pergunta atual

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz do Piauí'), // Título da aplicação
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nome da fase atual
            Text(
              fase.nome,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Texto da pergunta atual
            Text(
              pergunta.texto,
              style: TextStyle(fontSize: 24, color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Botões para as respostas
            ...pergunta.respostas.map(
              (resposta) => RespostaWidget(
                texto: resposta['text'] as String,
                isCorrect: resposta['isCorrect'] as bool,
                tema: fase.nome,
                isAnswered: isAnswered,
                corBotao: buttonColors[resposta['text'] as String],
                onResposta: () => responderPergunta(
                  resposta['isCorrect'] as bool,
                  fase.nome,
                  resposta['text'] as String,
                ),
              ),
            ),
            const Spacer(),
            // Exibe a pontuação atual do jogador
            Text(
              'Pontuação: $score',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget que representa cada resposta na tela do quiz
class RespostaWidget extends StatelessWidget {
  final String texto; // Texto da resposta
  final bool isCorrect; // Se a resposta está correta
  final String tema; // Tema da fase
  final bool isAnswered; // Se a pergunta foi respondida
  final Color? corBotao; // Cor do botão
  final VoidCallback onResposta; // Callback ao pressionar o botão

  const RespostaWidget({
    super.key,
    required this.texto,
    required this.isCorrect,
    required this.tema,
    required this.isAnswered,
    required this.corBotao,
    required this.onResposta,
  });

  @override
  Widget build(BuildContext context) {
    // Determina a cor do botão com base no estado atual
    final Color corFinal = corBotao ??
        (isAnswered
            ? (isCorrect ? Colors.green[800]! : Colors.red[800]!)
            : Colors.green[800]!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onResposta, // Executa a lógica ao pressionar o botão
        style: ElevatedButton.styleFrom(
          backgroundColor: corFinal, // Define a cor do botão
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          texto, // Texto exibido no botão
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

