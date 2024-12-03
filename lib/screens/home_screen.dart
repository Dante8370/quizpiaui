import 'package:flutter/material.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem temática
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background.jpg'), // Substitua pelo caminho da sua imagem
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
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela do quiz
                Navigator.pushNamed(context, '/quiz');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                padding:const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Iniciar Quiz',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            // Botão para informações
            OutlinedButton(
              onPressed: () {
                // Navegar para a tela de informações
                Navigator.pushNamed(context, '/info');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green[800]!, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Saiba Mais',
                style: TextStyle(fontSize: 18, color: Colors.green[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}