import 'package:flutter/material.dart';

class TelaInformacoes extends StatelessWidget {
  const TelaInformacoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text(
          'Informações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: const Center(
        child:  Text(
          'Saiba mais sobre o Quiz Piauiense!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}