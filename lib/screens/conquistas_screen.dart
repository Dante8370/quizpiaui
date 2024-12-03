import 'package:flutter/material.dart';

class TelaConquistas extends StatelessWidget {
  final List<String> conquistas;

  const TelaConquistas({super.key, required this.conquistas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquistas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: 
       Center(
         child: Column(
           children: [
             ListView.builder(
              itemCount: conquistas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(conquistas[index], style: const TextStyle(fontSize: 18),),
                  
                );
                
              },
              
                   ),
           ],
         ),
       ),
    );
  }
}
