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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Piauí: Desafio da História e Cultura',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Você sabia que o Piauí tem um legado histórico e cultural rico e fascinante, que vai muito além do que se ensina nas escolas? Se você é apaixonado por aprender mais sobre o estado, ou se quer desafiar seus conhecimentos, o Quiz Piauí é o aplicativo ideal para você!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Neste jogo envolvente, você será desafiado com perguntas sobre a história, cultura, tradições e personagens importantes do Piauí, passando por diversas fases temáticas, cada uma com uma proposta única e emocionante. Desde o início da colonização até os eventos mais recentes, você vai explorar tudo o que torna esse estado especial e cheio de histórias para contar.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              'O que torna o Quiz Piauí especial?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Aprendizado divertido: Através de perguntas interativas e fases criativas, o jogo transforma o aprendizado em uma experiência divertida e dinâmica, ideal para quem quer conhecer mais sobre o Piauí de maneira leve e descontraída.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              '• Fases temáticas: Cada fase do quiz é inspirada em um tema cultural ou histórico, o que garante que cada resposta certa te leve para um novo universo, com mais curiosidades sobre o estado.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              '• Desafios e progresso: A cada acerto, você avança, conquistando mais conhecimento sobre o Piauí e sendo desafiado por questões mais complexas. Seu progresso será registrado, permitindo que você se desafie a melhorar sua pontuação.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            const Text(
              '• Para todos os públicos: Seja você um piauiense de nascença ou alguém que tem curiosidade em conhecer a fundo a cultura desse estado, o Quiz Piauí é perfeito para todos que querem explorar mais sobre nossa história, cultura e identidade.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              'Valor para a sociedade',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Além de ser uma forma divertida de testar seus conhecimentos, o Quiz Piauí também contribui para a preservação e promoção da cultura local. Ele ajuda a manter viva a memória histórica do estado, estimulando o interesse de jovens e adultos pela rica diversidade cultural piauiense.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              'Incentivo ao estudo e à reflexão',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Com esse jogo, buscamos não só entreter, mas também incentivar o aprendizado contínuo e a reflexão sobre o Piauí. Afinal, entender nossa história é fundamental para compreender o presente e ajudar a construir o futuro.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Text(
              'Baixe o Quiz Piauí e embarque nessa jornada de descobertas! Quanto mais você jogar, mais aprenderá sobre o estado e, de quebra, se divertirá enquanto desafia seus conhecimentos! Vamos juntos celebrar a história, cultura e identidade do nosso querido Piauí!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
