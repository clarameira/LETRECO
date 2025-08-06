// import 'package:flutter/material.dart';

// class TelaBranca extends StatefulWidget {
//   const TelaBranca({super.key});

//   @override
//   State<TelaBranca> createState() => _TelaBrancaState();
// }

// class _TelaBrancaState extends State<TelaBranca> {
//   List<String> letras = ['', '', '', '', '']; // Caixinhas vazias
//   int posicaoSelecionada = 0; // Qual caixinha foi clicada

//   void adicionarLetra(String letra) {
//     setState(() {
//       letras[posicaoSelecionada] = letra;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewInsets = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('letreco'),
//         backgroundColor: Colors.green,
//       ),
//      body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//                     'letreco',
//                     style: TextStyle(
//                       fontSize: 48,
//                       color: Colors.green,
//                     ),
//                   ),
//                   SizedBox(width: 20,),
//                   Text( 
//                    'tema',
//                     style: TextStyle(
//                       fontSize: 36,
//                       color: Colors.green,
//                     ),
//                   ),
//                   SizedBox(width: 20,),
//                   Text(
//                     'erradicação da pobreza',
//                     style: TextStyle(
//                       fontSize: 20
//                     ),
//                   ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(5, (index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     posicaoSelecionada = index;
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.all(8),
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: posicaoSelecionada == index
//                         ? Colors.grey
//                         : Colors.grey,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     letras[index],
//                     style: const TextStyle(fontSize: 30, color: Colors.white),
//                   ),
//                 ),
//               );
//             }),
//           ),

//           const SizedBox(height: 20),
//         Positioned(
//           bottom: 77 + viewInsets, // 22 (teclado) + 10 (espaço) + altura do botão (45)
//           left: MediaQuery.of(context).size.width / 2 - 143 / 2,
//           child: SizedBox(
//             width: 143,
//             height: 33,
//             child: ElevatedButton(
//               onPressed: () {
//                 // ação do botão "Tentar"
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//               child: const Text(
//                 'Tentar',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const Spacer(), // empurra o teclado para baixo
//     Padding(
//       padding: const EdgeInsets.only(bottom: 22),
//       child: Wrap(
//         spacing: 10,
//         runSpacing: 10,
//         alignment: WrapAlignment.center,
//         children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letra) {
//           return SizedBox(
//             height: 45,
//             width: 45,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 alignment: Alignment.center,
//                 backgroundColor: const Color.fromARGB(255, 176, 175, 175),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 padding: EdgeInsets.zero,
//               ),
//               onPressed: () => adicionarLetra(letra),
//               child: Text(
//                 letra,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     ),
//   ],
// ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class TelaBranca extends StatefulWidget {
  const TelaBranca({super.key});

  @override
  State<TelaBranca> createState() => _TelaBrancaState();
}

class _TelaBrancaState extends State<TelaBranca> {
  final List<String> palavras = ["AJUDA", "RENDA", "MORAR", "DIGNO", "ACOES"];
  late String palavraSorteada;
  List<List<String>> tentativas = List.generate(5, (_) => List.filled(5, ''));
  List<List<int>> estados = List.generate(5, (_) => List.filled(5, 0));
  int tentativaAtual = 0;
  int posicaoSelecionada = 0;
  bool jogoFinalizado = false;
  bool vitoria = false;

  @override
  void initState() {
    super.initState();
    palavraSorteada = palavras[DateTime.now().day % palavras.length].toUpperCase();
  }

  void _adicionarLetra(String letra) {
    if (jogoFinalizado) return;
    
    setState(() {
      if (letra == '⌫') {
        // Corrigido: sempre apaga a letra atual primeiro
        if (posicaoSelecionada > 0) {
          tentativas[tentativaAtual][posicaoSelecionada - 1] = '';
          posicaoSelecionada--;
        }
      } else if (posicaoSelecionada < 5) {
        tentativas[tentativaAtual][posicaoSelecionada] = letra;
        if (posicaoSelecionada < 5) {
          posicaoSelecionada++;
        }
      }
    });
  }

  void _verificarPalavra() {
    if (tentativas[tentativaAtual].contains('')) return;
    
    String palavraDigitada = tentativas[tentativaAtual].join();
    List<int> estadoAtual = List.filled(5, 0);
    
    for (int i = 0; i < 5; i++) {
      if (palavraDigitada[i] == palavraSorteada[i]) {
        estadoAtual[i] = 2;
      }
    }
    
    for (int i = 0; i < 5; i++) {
      if (estadoAtual[i] == 2) continue;
      
      if (palavraSorteada.contains(palavraDigitada[i])) {
        int ocorrenciasPalavra = palavraSorteada.split(palavraDigitada[i]).length - 1;
        int jaMarcadas = 0;
        for (int j = 0; j < 5; j++) {
          if (palavraDigitada[j] == palavraDigitada[i] && estadoAtual[j] > 0) {
            jaMarcadas++;
          }
        }
        
        if (jaMarcadas < ocorrenciasPalavra) {
          estadoAtual[i] = 1;
        }
      } else {
        estadoAtual[i] = -1; // Letra não existe na palavra
      }
    }
    
    setState(() {
      for (int i = 0; i < 5; i++) {
        estados[tentativaAtual][i] = estadoAtual[i];
      }
      
      if (palavraDigitada == palavraSorteada) {
        jogoFinalizado = true;
        vitoria = true;
        _mostrarResultado("Você acertou!");
        return;
      }
      
      tentativaAtual++;
      posicaoSelecionada = 0;
      
      if (tentativaAtual >= 5) {
        jogoFinalizado = true;
        _mostrarResultado("A palavra era: $palavraSorteada");
      }
    });
  }

  void _mostrarResultado(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(vitoria ? "Parabéns!" : "Fim de jogo"),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (vitoria) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Color _getCorCaixa(int tentativa, int posicao) {
    switch (estados[tentativa][posicao]) {
      case 1: return Colors.yellow;
      case 2: return Colors.green;
      case -1: return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('LETRECO'),
        backgroundColor: Colors.green,
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
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'TEMA',
              style: TextStyle(
                fontSize: 28,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Erradicação da pobreza',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Grade de tentativas
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
                          color: tentativa == tentativaAtual && 
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
            
            // Botão Tentar
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: 143,
                height: 33,
                child: ElevatedButton(
                  onPressed: !jogoFinalizado && tentativas[tentativaAtual].join().length == 5
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
            
            // Teclado virtual com nova distribuição
            Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                children: [
                  // Primeira linha (7 letras)
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
                            backgroundColor: const Color.fromARGB(255, 176, 175, 175),
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
                  
                  // Segunda linha (7 letras)
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
                            backgroundColor: const Color.fromARGB(255, 176, 175, 175),
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
                  
                  // Terceira linha (7 letras)
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
                            backgroundColor: const Color.fromARGB(255, 176, 175, 175),
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
                  
                  // Quarta linha (5 letras + backspace)
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
                              backgroundColor: const Color.fromARGB(255, 176, 175, 175),
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
                      
                      // Botão de backspace
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