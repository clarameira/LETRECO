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
  Map<String, int> estadoLetrasTeclado = {};
  int tentativaAtual = 0;
  int posicaoSelecionada = 0;
  bool jogoFinalizado = false;
  bool vitoria = false;

  @override
  void initState() {
    super.initState();
    _carregarJogo();
  }

  Future<void> _carregarJogo() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now();
    final dataHoje = DateTime(hoje.year, hoje.month, hoje.day).toString();
    
    // Verificar se é um novo dia
    final ultimaData = prefs.getString('ultimaDataJogo');
    
    if (ultimaData != dataHoje) {
      // NOVO DIA - iniciar jogo novo
      await _inicializarNovoJogo();
      await prefs.setString('ultimaDataJogo', dataHoje);
      await prefs.remove('jogoFinalizado');
      await prefs.remove('vitoria');
      await prefs.remove('tentativaAtual');
      await prefs.remove('posicaoSelecionada');
      await prefs.remove('tentativas');
      await prefs.remove('estados');
      await prefs.remove('tecladoKeys');
      await prefs.remove('tecladoValues');
    } else {
      // MESMO DIA - carregar estado salvo
      await _carregarEstadoSalvo();
    }
  }

  Future<void> _inicializarNovoJogo() async {
    final agora = DateTime.now();
    final diasNoAno = agora.difference(DateTime(agora.year, 1, 1)).inDays;
    final indiceODS = diasNoAno % todosODS.length;
    final palavrasODS = todosODS[indiceODS]['palavras'];
    final indicePalavra = agora.day % palavrasODS.length;

    setState(() {
      odsAtual = todosODS[indiceODS];
      palavraAtual = palavrasODS[indicePalavra];
      jogoFinalizado = false;
      vitoria = false;
      tentativaAtual = 0;
      posicaoSelecionada = 0;
      tentativas = List.generate(5, (_) => List.filled(5, ''));
      estados = List.generate(5, (_) => List.filled(5, 0));
      estadoLetrasTeclado = {};
    });
  }

  Future<void> _carregarEstadoSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      jogoFinalizado = prefs.getBool('jogoFinalizado') ?? false;
      vitoria = prefs.getBool('vitoria') ?? false;
      tentativaAtual = prefs.getInt('tentativaAtual') ?? 0;
      posicaoSelecionada = prefs.getInt('posicaoSelecionada') ?? 0;
    });

    // Carregar tentativas
    final tentativasSalvas = prefs.getStringList('tentativas');
    if (tentativasSalvas != null) {
      for (int i = 0; i < tentativasSalvas.length; i++) {
        tentativas[i] = tentativasSalvas[i].split(',');
      }
    }

    // Carregar estados
    final estadosSalvos = prefs.getStringList('estados');
    if (estadosSalvos != null) {
      for (int i = 0; i < estadosSalvos.length; i++) {
        estados[i] = estadosSalvos[i].split(',').map((e) => int.tryParse(e) ?? 0).toList();
      }
    }

    // Carregar teclado
    final tecladoKeys = prefs.getStringList('tecladoKeys');
    final tecladoValues = prefs.getStringList('tecladoValues');
    if (tecladoKeys != null && tecladoValues != null) {
      for (int i = 0; i < tecladoKeys.length; i++) {
        estadoLetrasTeclado[tecladoKeys[i]] = int.tryParse(tecladoValues[i]) ?? 0;
      }
    }

    // Garantir que a palavra do dia está correta
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

  Future<void> _salvarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool('jogoFinalizado', jogoFinalizado);
    await prefs.setBool('vitoria', vitoria);
    await prefs.setInt('tentativaAtual', tentativaAtual);
    await prefs.setInt('posicaoSelecionada', posicaoSelecionada);
    
    // Salvar tentativas
    final tentativasParaSalvar = tentativas.map((lista) => lista.join(',')).toList();
    await prefs.setStringList('tentativas', tentativasParaSalvar);
    
    // Salvar estados
    final estadosParaSalvar = estados.map((lista) => lista.join(',')).toList();
    await prefs.setStringList('estados', estadosParaSalvar);
    
    // Salvar teclado
    final tecladoKeys = estadoLetrasTeclado.keys.toList();
    final tecladoValues = tecladoKeys.map((k) => estadoLetrasTeclado[k].toString()).toList();
    await prefs.setStringList('tecladoKeys', tecladoKeys);
    await prefs.setStringList('tecladoValues', tecladoValues);
  }

  Future<void> _registrarTentativa(bool venceu) async {
    final hoje = DateTime.now().toString().split(' ')[0];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('resultado$hoje', venceu ? 'venceu' : 'perdeu');
    await _salvarEstado(); // Salvar estado após cada tentativa
  }

  void _adicionarLetra(String letra) {
    if (jogoFinalizado) return;
    setState(() {
      if (letra == '⌫') {
        if (posicaoSelecionada > 0 || tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
          if (tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
            tentativas[tentativaAtual][posicaoSelecionada] = '';
          } else {
            posicaoSelecionada--;
            tentativas[tentativaAtual][posicaoSelecionada] = '';
          }
        }
      } else if (posicaoSelecionada < 5) {
        tentativas[tentativaAtual][posicaoSelecionada] = letra;
        if (posicaoSelecionada < 4) {
          posicaoSelecionada++;
        }
      }
      _salvarEstado(); // Salvar estado após cada letra adicionada
    });
  }

  void _verificarPalavra() async {
    if (tentativas[tentativaAtual].contains('')) return;

    String palavraDigitada = tentativas[tentativaAtual].join();
    bool acertou = palavraDigitada == palavraAtual;

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

    // Atualizar estado das letras no teclado
    for (int i = 0; i < 5; i++) {
      final letra = tentativas[tentativaAtual][i];
      if (letra.isNotEmpty) {
        if (estadoAtual[i] == 2) {
          estadoLetrasTeclado[letra] = 2;
        } else if (estadoAtual[i] == 1 && estadoLetrasTeclado[letra] != 2) {
          estadoLetrasTeclado[letra] = 1;
        } else if (estadoAtual[i] == -1 && estadoLetrasTeclado[letra] == 0) {
          estadoLetrasTeclado[letra] = -1;
        }
      }
    }

    setState(() {
      for (int i = 0; i < 5; i++) {
        estados[tentativaAtual][i] = estadoAtual[i];
      }

      if (acertou) {
        jogoFinalizado = true;
        vitoria = true;
        _mostrarResultado("Parabéns você acertou!\nA palavra é: $palavraAtual");
        return;
      }

      tentativaAtual++;
      posicaoSelecionada = 0;

      if (tentativaAtual >= 5) {
        jogoFinalizado = true;
        _mostrarResultado("Infelizmente você errou, não desista e tente novamente amanhã\nA palavra é: $palavraAtual");
      }
    });

    await _salvarEstado(); // Salvar estado após verificação
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

  Color _getCorTeclado(String letra) {
    final estado = estadoLetrasTeclado[letra];
    
    if (estado == 2) {
      return const Color.fromARGB(255, 7, 255, 7).withOpacity(0.7);
    } else if (estado == 1) {
      return const Color.fromARGB(255, 176, 175, 175).withOpacity(0.1);
    } else {
      return const Color.fromARGB(255, 176, 175, 175);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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

            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 'QWERTYUIOP'.split('').map((letra) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        width: 32,
                        height: 41,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra(letra),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: _getCorTeclado(letra),
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
                    children: 'ASDFGHJKL'.split('').map((letra) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        width: 32,
                        height: 41,
                        child: ElevatedButton(
                          onPressed: () => _adicionarLetra(letra),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: _getCorTeclado(letra),
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
                      ...'ZXCVBNM'.split('').map((letra) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          width: 32,
                          height: 41,
                          child: ElevatedButton(
                            onPressed: () => _adicionarLetra(letra),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: _getCorTeclado(letra),
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
                        width: 34,
                        height: 41,
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