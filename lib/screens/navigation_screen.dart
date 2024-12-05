import 'package:flutter/material.dart';
import 'package:quizpiaui/screens/conquistas_screen.dart';
import 'package:quizpiaui/screens/home_screen.dart';
import 'package:quizpiaui/screens/information_screen.dart';

class NavigationComponent extends StatefulWidget {
  const NavigationComponent({super.key});

  @override
  NavigationComponentState createState() => NavigationComponentState();
}

class NavigationComponentState extends State<NavigationComponent> {
  int paginaAtual = 0;

  // Lista para armazenar as conquistas
  List<String> conquistas = [];

  // Lista das telas para navegação
  final List<Widget> telas = [
    const TelaHome(),
    const TelaConquistas(),  // Passando a lista de conquistas inicialmente vazia
    const TelaInformacoes(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: telas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Conquistas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informações',
          ),
        ],
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    );
  }
}

