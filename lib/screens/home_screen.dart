import 'package:flutter/material.dart';
import 'package:quizpiaui/screens/database_helper.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizScreen');

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  // Função que reseta o quiz
  void resetarQuiz() async {
    final db = await DatabaseHelper().database;

    // Limpar o progresso e as conquistas do banco de dados
    await db.delete('progresso');
    await db.delete('conquistas');
    await db.delete('progresso_tema');
    _logger.info("Quiz resetado!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text(
          'Quiz Piauiense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Imagem de fundo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagem de avatar ou logo do app
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/tatu.png'), // Substitua pelo caminho da sua imagem
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Título
              Text(
                'Bem-vindo ao Quiz Piauiense!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Botão para iniciar o quiz
              ElevatedButton.icon(
                onPressed: () {
                  // Resetar progresso antes de começar o quiz
                  resetarQuiz();

                  // Navegar para a tela do quiz
                  Navigator.pushNamed(context, '/quiz');
                },
                icon: const Icon(Icons.play_arrow, size: 30), // Ícone de play
                label: const Text(
                  'Iniciar Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Botão para continuar de onde parou
              ElevatedButton.icon(
                onPressed: () {
                  // Navegar para a tela do quiz sem resetar o progresso
                  Navigator.pushNamed(context, '/quiz');
                },
                icon: const Icon(Icons.arrow_forward, size: 30), // Ícone de continuar
                label: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
