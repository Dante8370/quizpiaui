  class Pergunta {
  final String texto;
  final String categoria; 
  final List<Map<String, Object>> respostas;

  Pergunta({required this.texto,required this.categoria, required this.respostas});
}

class Fase {
  final String nome;
  final List<Pergunta> perguntas;

  Fase({required this.nome, required this.perguntas});
}


List<Fase> obterFases() {
  return [
    Fase(
      nome: 'Fase 1',
      perguntas: [
        Pergunta(
          texto: 'Qual é a capital do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Teresina', 'isCorrect': true},
            {'text': 'Parnaíba', 'isCorrect': false},
            {'text': 'Picos', 'isCorrect': false},
            {'text': 'Floriano', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'O Piauí faz divisa com quantos estados?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': '6', 'isCorrect': true},
            {'text': '7', 'isCorrect': false},
            {'text': '5', 'isCorrect': false},
            {'text': '4', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é o principal rio do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Rio Parnaíba', 'isCorrect': true},
            {'text': 'Rio São Francisco', 'isCorrect': false},
            {'text': 'Rio Amazonas', 'isCorrect': false},
            {'text': 'Rio Tocantins', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é o maior município do Piauí em extensão territorial?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Campo Maior', 'isCorrect': false},
            {'text': 'Teresina', 'isCorrect': false},
            {'text': 'Parnaíba', 'isCorrect': false},
            {'text': 'Gilbués', 'isCorrect': true},
          ],
        ),
        Pergunta(
          texto: 'Qual o evento cultural mais famoso do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Carnaval de Teresina', 'isCorrect': false},
            {'text': 'Festival de Inverno de Pedro II', 'isCorrect': true},
            {'text': 'Festa de Nossa Senhora da Vitória', 'isCorrect': false},
            {'text': 'Festa Junina de São João do Piauí', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Em que ano o Piauí foi fundado?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': '1822', 'isCorrect': false},
            {'text': '1889', 'isCorrect': false},
            {'text': '1865', 'isCorrect': true},
            {'text': '1759', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é a principal atividade econômica do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Agronegócio', 'isCorrect': true},
            {'text': 'Turismo', 'isCorrect': false},
            {'text': 'Indústria de tecnologia', 'isCorrect': false},
            {'text': 'Pesca', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é a religião predominante no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Protestantismo', 'isCorrect': false},
            {'text': 'Catolicismo', 'isCorrect': true},
            {'text': 'Espiritismo', 'isCorrect': false},
            {'text': 'Umbanda', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é o ponto turístico mais conhecido de Teresina?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Praça Pedro II', 'isCorrect': false},
            {'text': 'Encontro dos Rios', 'isCorrect': true},
            {'text': 'Museu do Piauí', 'isCorrect': false},
            {'text': 'Palácio Karnak', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'O Piauí é o único estado do Brasil a não ter litoral. Verdadeiro ou falso?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Verdadeiro', 'isCorrect': false},
            {'text': 'Falso', 'isCorrect': true},
          ],
        ),
      ],
    ),

    Fase(
      nome: 'Fase 2 - Fauna Piauiense',
      perguntas: [
        Pergunta(
          texto: 'Qual é o animal símbolo do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Onça-pintada', 'isCorrect': true},
            {'text': 'Tartaruga', 'isCorrect': false},
            {'text': 'Águia', 'isCorrect': false},
            {'text': 'Tamanduá', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Em que bioma o Piauí está inserido, onde há uma grande diversidade de fauna?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Cerrado', 'isCorrect': true},
            {'text': 'Mata Atlântica', 'isCorrect': false},
            {'text': 'Caatinga', 'isCorrect': false},
            {'text': 'Pantanal', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual desses animais é encontrado no Parque Nacional de Jericoacoara, no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Cervo-do-pantanal', 'isCorrect': true},
            {'text': 'Macaco-prego', 'isCorrect': false},
            {'text': 'Lobo-guará', 'isCorrect': false},
            {'text': 'Tamanduá-bandeira', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual é a principal característica do animal "lobo-guará", que pode ser encontrado no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'É o maior canídeo da América do Sul', 'isCorrect': true},
            {'text': 'Vive apenas em áreas urbanas', 'isCorrect': false},
            {'text': 'É um predador noturno', 'isCorrect': false},
            {'text': 'Tem hábitos exclusivamente carnívoros', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Onde é possível encontrar a espécie de peixe "curimatá", que é típica do Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Nos rios e lagos do Piauí', 'isCorrect': true},
            {'text': 'Apenas na costa do estado', 'isCorrect': false},
            {'text': 'Exclusivamente no Rio São Francisco', 'isCorrect': false},
            {'text': 'Nas áreas do cerrado', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual desses répteis é comum no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Cascavel', 'isCorrect': true},
            {'text': 'Cobra coral', 'isCorrect': false},
            {'text': 'Jiboia', 'isCorrect': false},
            {'text': 'Anaconda', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'O que caracteriza a fauna do Parque Nacional Serra da Capivara, no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Grande diversidade de aves e mamíferos', 'isCorrect': true},
            {'text': 'Presença de apenas espécies aquáticas', 'isCorrect': false},
            {'text': 'Pouca diversidade de fauna', 'isCorrect': false},
            {'text': 'Predominância de répteis', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual desses animais é uma espécie ameaçada de extinção no Piauí?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Arara-azul', 'isCorrect': true},
            {'text': 'Jaguatirica', 'isCorrect': false},
            {'text': 'Tamanduá-bandeira', 'isCorrect': false},
            {'text': 'Mico-leão-dourado', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'A quati é um animal que pode ser encontrado em áreas do Piauí. Qual sua principal alimentação?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Frutas, insetos e pequenos vertebrados', 'isCorrect': true},
            {'text': 'Somente folhas', 'isCorrect': false},
            {'text': 'Peixes e moluscos', 'isCorrect': false},
            {'text': 'Pequenos roedores', 'isCorrect': false},
          ],
        ),
        Pergunta(
          texto: 'Qual animal é conhecido por viver nas áreas de caatinga do Piauí e é adaptado ao clima seco?',
          categoria: 'História do Piauí',
          respostas: [
            {'text': 'Veado-catingueiro', 'isCorrect': true},
            {'text': 'Lobo-guará', 'isCorrect': false},
            {'text': 'Jacaré-do-pantanal', 'isCorrect': false},
            {'text': 'Javali', 'isCorrect': false},
          ],
        ),
      ],
    ),

    // Outras fases podem ser adicionadas aqui
  ];
}
