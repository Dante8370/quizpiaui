import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('QuizScreen');

class TelaConquistas extends StatefulWidget {
  const TelaConquistas({super.key});

  @override
  TelaConquistasState createState() => TelaConquistasState();
}

class TelaConquistasState extends State<TelaConquistas> {
  List<String> conquistas = [];
  bool isLoading = true; // Indicador de carregamento

  @override
  void initState() {
    super.initState();
    _carregarConquistas();
  }

  void _carregarConquistas() async {
    try {
      var conquistasDoBanco = await DatabaseHelper().carregarConquistas();
      setState(() {
        conquistas = conquistasDoBanco
            .map((item) => item['conquista'] as String)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      _logger.info("Erro ao carregar conquistas: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center( // Centraliza o título no AppBar
          child: Text('Conquistas'),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/imgconquistas.jpg'), // Imagem de fundo
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), 
              BlendMode.darken, 
            ),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Indicador de carregamento
            : conquistas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma conquista alcançada ainda!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: conquistas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.white.withOpacity(0.8), // Transparência no fundo do card
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(  // Substitui a estrela por uma imagem
                            'assets/conquistas.png', // Substitua pelo caminho da sua imagem
                            width: 30,  // Ajuste o tamanho da imagem
                            height: 30, // Ajuste o tamanho da imagem
                          ),
                          title: Text(
                            conquistas[index],
                            style: const TextStyle(fontSize: 18,),
                          ),
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
