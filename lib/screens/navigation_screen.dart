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
    const TelaConquistas(conquistas: []),  // Passando a lista de conquistas inicialmente vazia
    const TelaInformacoes(),
  ];

  void atualizarTelaConquistas() {
    // Atualiza a tela de conquistas com a lista mais recente de conquistas
    setState(() {
      telas[1] = TelaConquistas(conquistas: conquistas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: telas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
            if (index == 1) {
              // Quando for para a tela de conquistas, atualiza a tela com as conquistas mais recentes
              atualizarTelaConquistas();
            }
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

