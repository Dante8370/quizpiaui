import 'package:flutter/material.dart';
import 'package:quizpiaui/screens/navigation_screen.dart';
import 'package:quizpiaui/screens/quiz_game.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NavigationComponent(), // Tela inicial
      routes: {
        '/quiz': (context) => const QuizScreen(), // Definição da rota para o quiz
      },
    );
  }
}
