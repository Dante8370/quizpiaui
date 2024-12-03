import 'package:flutter/material.dart';

class TelaConquistas extends StatelessWidget {
  final List<String> conquistas;

  const TelaConquistas({super.key, required this.conquistas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquistas'),
        backgroundColor: Colors.green[800],
      ),
      body: conquistas.isEmpty
          ? const Center(
              child: Text('Nenhuma conquista alcançada ainda!'),
            )
          : ListView.builder(
              itemCount: conquistas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(
                    conquistas[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
