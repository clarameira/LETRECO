// import 'package:flutter/material.dart';

// class TelaBranca extends StatefulWidget {
//   const TelaBranca({super.key});

//   @override
//   State<TelaBranca> createState() => _TelaBrancaState();
// }

// class _TelaBrancaState extends State<TelaBranca> {
//   // Lista completa de todos os ODS com seus temas e palavras
//   final List<Map<String, dynamic>> todosODS = [
//     {
//       'numero': 1,
//       'tema': 'Erradicação da pobreza',
//       'palavras': ["AJUDA", "RENDA", "MORAR", "DIGNO", "ACOES"],
//     },
//     {
//       'numero': 2,
//       'tema': 'Fome Zero e Agricultura Sustentável',
//       'palavras': ["HORTA", "FRUTA", "GRAMA", "FOLHA", "GRAOS"],
//     },
//     {
//       'numero': 3,
//       'tema': 'Saúde e Bem-estar',
//       'palavras': ["SAUDE", "IMUNE", "CURAS", "CORPO", "MENTE"],
//     },
//     {
//       'numero': 4,
//       'tema': 'Educação de Qualidade',
//       'palavras': ["LIVRO", "SABER", "LICAO", "AULAS", "PAPEL"],
//     },
//     {
//       'numero': 5,
//       'tema': 'Igualdade de Gênero',
//       'palavras': ["LUTAR", "FORCA", "APOIO", "VOZES", "VALOR"],
//     },
//     {
//       'numero': 6,
//       'tema': 'Água potável e saneamento',
//       'palavras': ["LIMPO", "CHUVA", "BANHO", "LAVAR", "CANAL"],
//     },
//     {
//       'numero': 7,
//       'tema': 'Energia Limpa e Acessível',
//       'palavras': ["VENTO", "SOLAR", "LUZES", "FONTE", "CALOR"],
//     },
//     {
//       'numero': 8,
//       'tema': 'Trabalho decente e crescimento Econômico',
//       'palavras': ["VENDA", "LUCRO", "CONTA", "SETOR", "BANCO"],
//     },
//     {
//       'numero': 9,
//       'tema': 'Indústria inovação e infraestrutura',
//       'palavras': ["PONTE", "FERRO", "TORRE", "OBRAS", "USINA"],
//     },
//     {
//       'numero': 10,
//       'tema': 'Redução das desigualdades',
//       'palavras': ["LACOS", "NORMA", "ETNIA", "RACAS", "IGUAL"],
//     },
//     {
//       'numero': 11,
//       'tema': 'Cidades e Comunidades Sustentáveis',
//       'palavras': ["PRACA", "CASAS", "CORES", "LUGAR", "LAZER"],
//     },
//     {
//       'numero': 12,
//       'tema': 'Consumo e produção responsáveis',
//       'palavras': ["REUSO", "CICLO", "ETAPA", "RESTO", "TERRA"],
//     },
//     {
//       'numero': 13,
//       'tema': 'Ação Contra a Mudança Global do Clima',
//       'palavras': ["CLIMA", "RISCO", "GLOBO", "SECAS", "GASES"],
//     },
//     {
//       'numero': 14,
//       'tema': 'Vida na água',
//       'palavras': ["PEIXE", "MARES", "ACUDE", "ALGAS", "ONDAS"],
//     },
//     {
//       'numero': 15,
//       'tema': 'Vida Terrestre',
//       'palavras': ["FLORA", "FAUNA", "BICHO", "SERES", "VIDAS"],
//     },
//     {
//       'numero': 16,
//       'tema': 'Paz, Justiça e Instituições Eficazes',
//       'palavras': ["JUSTO", "NACAO", "ETICA", "REGRA", "ORDEM"],
//     },
//     {
//       'numero': 17,
//       'tema': 'Parcerias e Meios de Implementação',
//       'palavras': ["UNIAO", "JUNTO", "GRUPO", "PACTO", "MEIOS"],
//     },
//   ];

//   // Variáveis do jogo com valores iniciais
//   Map<String, dynamic> odsAtual = {
//     'numero': 1,
//     'tema': 'Carregando...',
//     'palavras': ["CARGA", "CARGA", "CARGA", "CARGA", "CARGA"]
//   };
//   String palavraAtual = "CARGA";
//   List<List<String>> tentativas = List.generate(5, (_) => List.filled(5, ''));
//   List<List<int>> estados = List.generate(5, (_) => List.filled(5, 0));
//   int tentativaAtual = 0;
//   int posicaoSelecionada = 0;
//   bool jogoFinalizado = false;
//   bool vitoria = false;

//   @override
//   void initState() {
//     super.initState();
//     _inicializarJogo();
//   }

//   void _inicializarJogo() {
//     final agora = DateTime.now();
//     try {
//       // Calcula índice do ODS baseado no dia do ano
//       final inicioAno = DateTime(agora.year, 1, 1);
//       final diasNoAno = agora.difference(inicioAno).inDays;
//       final indiceODS = diasNoAno % todosODS.length;

//       // Seleciona palavra baseada no dia do mês
//       final palavrasODS = todosODS[indiceODS]['palavras'];
//       final indicePalavra = agora.day % palavrasODS.length;

//       setState(() {
//         odsAtual = todosODS[indiceODS];
//         palavraAtual = palavrasODS[indicePalavra];
//       });

//       debugPrint('ODS: ${odsAtual['tema']}');
//       debugPrint('Palavra: $palavraAtual');
//     } catch (e) {
//       debugPrint('Erro ao inicializar jogo: $e');
//       // Mantém valores padrão em caso de erro
//     }
//   }

//   void _adicionarLetra(String letra) {
//     if (jogoFinalizado) return;

//     setState(() {
//       if (letra == '⌫') {
//         // Apaga a letra atual
//         if (posicaoSelecionada > 0 || tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
//           if (tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
//             tentativas[tentativaAtual][posicaoSelecionada] = '';
//           } else {
//             posicaoSelecionada--;
//             tentativas[tentativaAtual][posicaoSelecionada] = '';
//           }
//         }
//       } else if (posicaoSelecionada < 5) {
//         tentativas[tentativaAtual][posicaoSelecionada] = letra;
//         if (posicaoSelecionada < 4) {
//           posicaoSelecionada++;
//         }
//       }
//     });
//   }

//   void _verificarPalavra() {
//     if (tentativas[tentativaAtual].contains('')) return;

//     String palavraDigitada = tentativas[tentativaAtual].join();
//     List<int> estadoAtual = List.filled(5, 0);

//     // Verifica letras na posição correta
//     for (int i = 0; i < 5; i++) {
//       if (palavraDigitada[i] == palavraAtual[i]) {
//         estadoAtual[i] = 2;
//       }
//     }

//     // Verifica letras existentes em posição errada
//     for (int i = 0; i < 5; i++) {
//       if (estadoAtual[i] == 2) continue;

//       if (palavraAtual.contains(palavraDigitada[i])) {
//         int ocorrencias = palavraAtual.split(palavraDigitada[i]).length - 1;
//         int marcadas = 0;
//         for (int j = 0; j < 5; j++) {
//           if (palavraDigitada[j] == palavraDigitada[i] && estadoAtual[j] > 0) {
//             marcadas++;
//           }
//         }

//         if (marcadas < ocorrencias) {
//           estadoAtual[i] = 1;
//         }
//       } else {
//         estadoAtual[i] = -1; // Letra não existe
//       }
//     }

//     setState(() {
//       for (int i = 0; i < 5; i++) {
//         estados[tentativaAtual][i] = estadoAtual[i];
//       }

//       if (palavraDigitada == palavraAtual) {
//         jogoFinalizado = true;
//         vitoria = true;
//         _mostrarResultado("Você acertou!");
//         return;
//       }

//       tentativaAtual++;
//       posicaoSelecionada = 0;

//       if (tentativaAtual >= 5) {
//         jogoFinalizado = true;
//         _mostrarResultado("A palavra era: $palavraAtual");
//       }
//     });
//   }

//   void _mostrarResultado(String mensagem) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(vitoria ? "Parabéns!" : "Fim de jogo"),
//         content: Text(mensagem),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               if (vitoria) {
//                 Navigator.of(context).pop();
//               }
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getCorCaixa(int tentativa, int posicao) {
//     switch (estados[tentativa][posicao]) {
//       case 1: return Colors.yellow;
//       case 2: return Colors.green;
//       case -1: return Colors.red;
//       default: return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('LETRECO'),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             const Text(
//               'LETRECO',
//               style: TextStyle(
//                 fontSize: 36,
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               'ODS ${odsAtual['numero']}',
//               style: const TextStyle(
//                 fontSize: 28,
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               odsAtual['tema'],
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),

//             // Grade de tentativas
//             Column(
//               children: List.generate(5, (tentativa) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(5, (posicao) {
//                     return Container(
//                       margin: const EdgeInsets.all(4),
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: _getCorCaixa(tentativa, posicao),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: tentativa == tentativaAtual &&
//                                  posicao == posicaoSelecionada &&
//                                  !jogoFinalizado
//                               ? Colors.blue
//                               : Colors.transparent,
//                           width: 2,
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         tentativas[tentativa][posicao],
//                         style: const TextStyle(
//                           fontSize: 28,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               }),
//             ),

//             const Spacer(),

//             // Botão Tentar
//             Padding(
//               padding: const EdgeInsets.only(bottom: 15),
//               child: SizedBox(
//                 width: 143,
//                 height: 33,
//                 child: ElevatedButton(
//                   onPressed: !jogoFinalizado && tentativas[tentativaAtual].join().length == 5
//                       ? _verificarPalavra
//                       : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'TENTAR',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Teclado virtual
//             Padding(
//               padding: const EdgeInsets.only(bottom: 22),
//               child: Column(
//                 children: [
//                   // Linhas do teclado (3 linhas com 7 letras)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: 'ABCDEFG'.split('').map((letra) {
//                       return Container(
//                         margin: const EdgeInsets.all(2),
//                         width: 38,
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () => _adicionarLetra(letra),
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             backgroundColor: const Color.fromARGB(255, 176, 175, 175),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             letra,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: 'HIJKLMN'.split('').map((letra) {
//                       return Container(
//                         margin: const EdgeInsets.all(2),
//                         width: 38,
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () => _adicionarLetra(letra),
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             backgroundColor: const Color.fromARGB(255, 176, 175, 175),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             letra,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: 'OPQRSTU'.split('').map((letra) {
//                       return Container(
//                         margin: const EdgeInsets.all(2),
//                         width: 38,
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () => _adicionarLetra(letra),
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             backgroundColor: const Color.fromARGB(255, 176, 175, 175),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             letra,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),

//                   // Última linha com 5 letras + backspace
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ...'VWXYZ'.split('').map((letra) {
//                         return Container(
//                           margin: const EdgeInsets.all(2),
//                           width: 38,
//                           height: 45,
//                           child: ElevatedButton(
//                             onPressed: () => _adicionarLetra(letra),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               backgroundColor: const Color.fromARGB(255, 176, 175, 175),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               letra,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),

//                       // Botão de apagar
//                       Container(
//                         margin: const EdgeInsets.all(2),
//                         width: 38,
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () => _adicionarLetra('⌫'),
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.backspace,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaBranca extends StatefulWidget {
  const TelaBranca({super.key});

  @override
  State<TelaBranca> createState() => _TelaBrancaState();
}

class _TelaBrancaState extends State<TelaBranca> {
  final List<Map<String, dynamic>> todosODS = [
    {
      'numero': 1,
      'tema': 'Erradicação da pobreza',
      'palavras': ["AJUDA", "RENDA", "MORAR", "DIGNO", "ACOES"],
    },
    {
      'numero': 2,
      'tema': 'Fome Zero e Agricultura Sustentável',
      'palavras': ["HORTA", "FRUTA", "GRAMA", "FOLHA", "GRAOS"],
    },
    {
      'numero': 3,
      'tema': 'Saúde e Bem-estar',
      'palavras': ["SAUDE", "IMUNE", "CURAS", "CORPO", "MENTE"],
    },
    {
      'numero': 4,
      'tema': 'Educação de Qualidade',
      'palavras': ["LIVRO", "SABER", "LICAO", "AULAS", "PAPEL"],
    },
    {
      'numero': 5,
      'tema': 'Igualdade de Gênero',
      'palavras': ["LUTAR", "FORCA", "APOIO", "VOZES", "VALOR"],
    },
    {
      'numero': 6,
      'tema': 'Água potável e saneamento',
      'palavras': ["LIMPO", "CHUVA", "BANHO", "LAVAR", "CANAL"],
    },
    {
      'numero': 7,
      'tema': 'Energia Limpa e Acessível',
      'palavras': ["VENTO", "SOLAR", "LUZES", "FONTE", "CALOR"],
    },
    {
      'numero': 8,
      'tema': 'Trabalho decente e crescimento Econômico',
      'palavras': ["VENDA", "LUCRO", "CONTA", "SETOR", "BANCO"],
    },
    {
      'numero': 9,
      'tema': 'Indústria inovação e infraestrutura',
      'palavras': ["PONTE", "FERRO", "TORRE", "OBRAS", "USINA"],
    },
    {
      'numero': 10,
      'tema': 'Redução das desigualdades',
      'palavras': ["LACOS", "NORMA", "ETNIA", "RACAS", "IGUAL"],
    },
    {
      'numero': 11,
      'tema': 'Cidades e Comunidades Sustentáveis',
      'palavras': ["PRACA", "CASAS", "CORES", "LUGAR", "LAZER"],
    },
    {
      'numero': 12,
      'tema': 'Consumo e produção responsáveis',
      'palavras': ["REUSO", "CICLO", "ETAPA", "RESTO", "TERRA"],
    },
    {
      'numero': 13,
      'tema': 'Ação Contra a Mudança Global do Clima',
      'palavras': ["CLIMA", "RISCO", "GLOBO", "SECAS", "GASES"],
    },
    {
      'numero': 14,
      'tema': 'Vida na água',
      'palavras': ["PEIXE", "MARES", "ACUDE", "ALGAS", "ONDAS"],
    },
    {
      'numero': 15,
      'tema': 'Vida Terrestre',
      'palavras': ["FLORA", "FAUNA", "BICHO", "SERES", "VIDAS"],
    },
    {
      'numero': 16,
      'tema': 'Paz, Justiça e Instituições Eficazes',
      'palavras': ["JUSTO", "NACAO", "ETICA", "REGRA", "ORDEM"],
    },
    {
      'numero': 17,
      'tema': 'Parcerias e Meios de Implementação',
      'palavras': ["UNIAO", "JUNTO", "GRUPO", "PACTO", "MEIOS"],
    },
  ];

  late Map<String, dynamic> odsAtual;
  late String palavraAtual;
  List<List<String>> tentativas = List.generate(5, (_) => List.filled(5, ''));
  List<List<int>> estados = List.generate(5, (_) => List.filled(5, 0));
  int tentativaAtual = 0;
  int posicaoSelecionada = 0;
  bool jogoFinalizado = false;
  bool vitoria = false;

  @override
  void initState() {
    super.initState();
    _inicializarJogo();
  }

  Future<void> _inicializarJogo() async {
    final agora = DateTime.now();
    final diasNoAno = agora.difference(DateTime(agora.year, 1, 1)).inDays;
    final indiceODS = diasNoAno % todosODS.length;
    final palavrasODS = todosODS[indiceODS]['palavras'];
    final indicePalavra = agora.day % palavrasODS.length;

    setState(() {
      odsAtual = todosODS[indiceODS];
      palavraAtual = palavrasODS[indicePalavra];
    });
  }

  Future<void> _registrarTentativa(bool venceu) async {
    final hoje = DateTime.now().toString().split(' ')[0];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimaDataJogo', hoje);
    await prefs.setString('resultado$hoje', venceu ? 'venceu' : 'perdeu');
  }

  void _adicionarLetra(String letra) {
    if (jogoFinalizado) return;

    setState(() {
      if (letra == '⌫') {
        if (posicaoSelecionada > 0) {
          tentativas[tentativaAtual][posicaoSelecionada - 1] = '';
          posicaoSelecionada--;
        }
      } else if (posicaoSelecionada < 5) {
        tentativas[tentativaAtual][posicaoSelecionada] = letra;
        if (posicaoSelecionada < 4) {
          posicaoSelecionada++;
        }
      }
    });
  }

  void _verificarPalavra() async {
    if (tentativas[tentativaAtual].contains('')) return;

    String palavraDigitada = tentativas[tentativaAtual].join();
    bool acertou = palavraDigitada == palavraAtual;

    // Only register after actual attempt
    await _registrarTentativa(acertou);

    List<int> estadoAtual = List.filled(5, 0);

    for (int i = 0; i < 5; i++) {
      if (palavraDigitada[i] == palavraAtual[i]) {
        estadoAtual[i] = 2;
      }
    }

    for (int i = 0; i < 5; i++) {
      if (estadoAtual[i] == 2) continue;

      if (palavraAtual.contains(palavraDigitada[i])) {
        int ocorrencias = palavraAtual.split(palavraDigitada[i]).length - 1;
        int marcadas = 0;
        for (int j = 0; j < 5; j++) {
          if (palavraDigitada[j] == palavraDigitada[i] && estadoAtual[j] > 0) {
            marcadas++;
          }
        }

        if (marcadas < ocorrencias) {
          estadoAtual[i] = 1;
        }
      } else {
        estadoAtual[i] = -1;
      }
    }

    setState(() {
      for (int i = 0; i < 5; i++) {
        estados[tentativaAtual][i] = estadoAtual[i];
      }

      if (acertou) {
        jogoFinalizado = true;
        vitoria = true;
        _mostrarResultado("Você acertou!");
        return;
      }

      tentativaAtual++;
      posicaoSelecionada = 0;

      if (tentativaAtual >= 5) {
        jogoFinalizado = true;
        _mostrarResultado("A palavra era: $palavraAtual");
      }
    });
  }

  void _mostrarResultado(String mensagem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(vitoria ? "Parabéns!" : "Fim de jogo"),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Color _getCorCaixa(int tentativa, int posicao) {
    switch (estados[tentativa][posicao]) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.green;
      case -1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text('LETRECO'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          
          children: [
            const SizedBox(height: 10),
            const Text(
              'LETRECO',
              style: TextStyle(
                fontSize: 36,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bungee',
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'ODS ${odsAtual['numero']}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              odsAtual['tema'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Column(
              children: List.generate(5, (tentativa) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (posicao) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getCorCaixa(tentativa, posicao),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              tentativa == tentativaAtual &&
                                  posicao == posicaoSelecionada &&
                                  !jogoFinalizado
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tentativas[tentativa][posicao],
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: 143,
                height: 33,
                child: ElevatedButton(
                  onPressed:
                      !jogoFinalizado &&
                          tentativas[tentativaAtual].join().length == 5
                      ? _verificarPalavra
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'TENTAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 'ABCDEFG'.split('').map((letra) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        width: 38,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra(letra),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color.fromARGB(
                              255,
                              176,
                              175,
                              175,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            letra,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 'HIJKLMN'.split('').map((letra) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        width: 38,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra(letra),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color.fromARGB(
                              255,
                              176,
                              175,
                              175,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            letra,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 'OPQRSTU'.split('').map((letra) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        width: 38,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra(letra),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color.fromARGB(
                              255,
                              176,
                              175,
                              175,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            letra,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...'VWXYZ'.split('').map((letra) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          width: 38,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () => _adicionarLetra(letra),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color.fromARGB(
                                255,
                                176,
                                175,
                                175,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              letra,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      Container(
                        margin: const EdgeInsets.all(2),
                        width: 38,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra('⌫'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(
                            Icons.backspace,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
