// Importa pacotes necessários para a interface do Flutter
import 'package:flutter/material.dart';
// Importa o arquivo para manipulação do banco de dados
import 'package:quizpiaui/screens/database_helper.dart';
// Importa o pacote de logging para registrar informações e eventos
import 'package:logging/logging.dart';

// Cria uma instância de Logger para registrar eventos específicos da tela
final Logger _logger = Logger('QuizScreen');

// Define um widget Stateless para a tela inicial do app
class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  // Função para resetar o progresso do quiz
  void resetarQuiz() async {
    // Obtém a instância do banco de dados
    final db = await DatabaseHelper().database;

    // Apaga todos os registros das tabelas relacionadas ao progresso e conquistas
    await db.delete('progresso');
    await db.delete('conquistas');
    await db.delete('progresso_tema');

    // Registra no logger que o quiz foi resetado
    _logger.info("Quiz resetado!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Define a cor de fundo da tela
      backgroundColor: Colors.lightGreen[100],

      // Barra de navegação na parte superior
      appBar: AppBar(
        // Título do aplicativo
        title: const Text(
          'Quiz Piauiense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centraliza o título na barra
        backgroundColor: Colors.green[800], // Define a cor de fundo da barra
      ),

      // Corpo da tela
      body: Container(
        // Adiciona um fundo com uma imagem
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Caminho da imagem de fundo
            fit: BoxFit.cover, // Ajusta a imagem para cobrir a tela
          ),
        ),

        // Centraliza os widgets na tela
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Alinha itens verticalmente no centro
            children: [
              // Exibe uma imagem circular como avatar ou logo do app
              Container(
                width: 200, // Largura do círculo
                height: 200, // Altura do círculo
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Forma circular
                  image: DecorationImage(
                    image: AssetImage('assets/tatu.png'), // Caminho da imagem
                    fit: BoxFit.cover, // Ajusta a imagem para cobrir o círculo
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento vertical

              // Título principal da tela
              Text(
                'Bem-vindo ao Quiz Piauiense!',
                style: TextStyle(
                  fontSize: 24, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.green[900], // Cor do texto
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              const SizedBox(height: 20), // Espaçamento vertical

              // Botão para iniciar o quiz
              ElevatedButton.icon(
                onPressed: () {
                  // Reseta o progresso do quiz antes de começar
                  resetarQuiz();

                  // Navega para a tela do quiz
                  Navigator.pushNamed(context, '/quiz');
                },
                icon: const Icon(Icons.play_arrow, size: 30), // Ícone de play
                label: const Text(
                  'Iniciar Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Estilo do texto
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800], // Cor do botão
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Espaçamento interno
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  ),
                ),
              ),
              const SizedBox(height: 10), // Espaçamento vertical

              // Botão para continuar de onde parou
              ElevatedButton.icon(
                onPressed: () {
                  // Navega para a tela do quiz sem resetar o progresso
                  Navigator.pushNamed(context, '/quiz');
                },
                icon: const Icon(Icons.arrow_forward, size: 30), // Ícone de continuar
                label: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Estilo do texto
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600], // Cor do botão
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Espaçamento interno
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                  ),
                ),
              ),
              const SizedBox(height: 10), // Espaçamento vertical
            ],
          ),
        ),
      ),
    );
  }
}
