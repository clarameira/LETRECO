import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/word_validator.dart';

class TelaBranca extends StatefulWidget {
  const TelaBranca({super.key});

  @override
  State<TelaBranca> createState() => _TelaBrancaState();
}

class _TelaBrancaState extends State<TelaBranca> with WidgetsBindingObserver {
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
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _configurarTelaCheia();
    _carregarJogo();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _restaurarUI();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _configurarTelaCheia();
    }
  }

  Future<void> _configurarTelaCheia() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  Future<void> _restaurarUI() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _carregarJogo() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now();
    final dataHoje = DateTime(hoje.year, hoje.month, hoje.day).toString();
    
    final ultimaData = prefs.getString('ultimaDataJogo');
    
    if (ultimaData != dataHoje) {
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

    final tentativasSalvas = prefs.getStringList('tentativas');
    if (tentativasSalvas != null) {
      for (int i = 0; i < tentativasSalvas.length; i++) {
        tentativas[i] = tentativasSalvas[i].split(',');
      }
    }

    final estadosSalvos = prefs.getStringList('estados');
    if (estadosSalvos != null) {
      for (int i = 0; i < estadosSalvos.length; i++) {
        estados[i] = estadosSalvos[i].split(',').map((e) => int.tryParse(e) ?? 0).toList();
      }
    }

    final tecladoKeys = prefs.getStringList('tecladoKeys');
    final tecladoValues = prefs.getStringList('tecladoValues');
    if (tecladoKeys != null && tecladoValues != null) {
      for (int i = 0; i < tecladoKeys.length; i++) {
        estadoLetrasTeclado[tecladoKeys[i]] = int.tryParse(tecladoValues[i]) ?? 0;
      }
    }

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
    
    final tentativasParaSalvar = tentativas.map((lista) => lista.join(',')).toList();
    await prefs.setStringList('tentativas', tentativasParaSalvar);
    
    final estadosParaSalvar = estados.map((lista) => lista.join(',')).toList();
    await prefs.setStringList('estados', estadosParaSalvar);
    
    final tecladoKeys = estadoLetrasTeclado.keys.toList();
    final tecladoValues = tecladoKeys.map((k) => estadoLetrasTeclado[k].toString()).toList();
    await prefs.setStringList('tecladoKeys', tecladoKeys);
    await prefs.setStringList('tecladoValues', tecladoValues);
  }

  Future<void> _registrarTentativa(bool venceu) async {
    final hoje = DateTime.now().toString().split(' ')[0];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('resultado$hoje', venceu ? 'venceu' : 'perdeu');
    await _salvarEstado();
  }

  void _selecionarPosicao(int tentativa, int posicao) {
    if (!jogoFinalizado && tentativa == tentativaAtual) {
      setState(() {
        posicaoSelecionada = posicao;
        
        if (posicaoSelecionada < 4 && tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
          for (int i = posicaoSelecionada + 1; i < 5; i++) {
            if (tentativas[tentativaAtual][i].isEmpty) {
              posicaoSelecionada = i;
              break;
            }
          }
        }
      });
    }
  }

  void _adicionarLetra(String letra) {
    if (jogoFinalizado) return;
    
    setState(() {
      if (letra == '⌫') {
        if (tentativas[tentativaAtual][posicaoSelecionada].isNotEmpty) {
          tentativas[tentativaAtual][posicaoSelecionada] = '';
          if (posicaoSelecionada > 0) {
            posicaoSelecionada--;
          }
        } else if (posicaoSelecionada > 0) {
          posicaoSelecionada--;
          tentativas[tentativaAtual][posicaoSelecionada] = '';
        }
      } else if (posicaoSelecionada < 5) {
        tentativas[tentativaAtual][posicaoSelecionada] = letra;
        if (posicaoSelecionada < 4) {
          posicaoSelecionada++;
        }
      }
      _salvarEstado();
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      
      if (key == LogicalKeyboardKey.keyA) _adicionarLetra('A');
      else if (key == LogicalKeyboardKey.keyB) _adicionarLetra('B');
      else if (key == LogicalKeyboardKey.keyC) _adicionarLetra('C');
      else if (key == LogicalKeyboardKey.keyD) _adicionarLetra('D');
      else if (key == LogicalKeyboardKey.keyE) _adicionarLetra('E');
      else if (key == LogicalKeyboardKey.keyF) _adicionarLetra('F');
      else if (key == LogicalKeyboardKey.keyG) _adicionarLetra('G');
      else if (key == LogicalKeyboardKey.keyH) _adicionarLetra('H');
      else if (key == LogicalKeyboardKey.keyI) _adicionarLetra('I');
      else if (key == LogicalKeyboardKey.keyJ) _adicionarLetra('J');
      else if (key == LogicalKeyboardKey.keyK) _adicionarLetra('K');
      else if (key == LogicalKeyboardKey.keyL) _adicionarLetra('L');
      else if (key == LogicalKeyboardKey.keyM) _adicionarLetra('M');
      else if (key == LogicalKeyboardKey.keyN) _adicionarLetra('N');
      else if (key == LogicalKeyboardKey.keyO) _adicionarLetra('O');
      else if (key == LogicalKeyboardKey.keyP) _adicionarLetra('P');
      else if (key == LogicalKeyboardKey.keyQ) _adicionarLetra('Q');
      else if (key == LogicalKeyboardKey.keyR) _adicionarLetra('R');
      else if (key == LogicalKeyboardKey.keyS) _adicionarLetra('S');
      else if (key == LogicalKeyboardKey.keyT) _adicionarLetra('T');
      else if (key == LogicalKeyboardKey.keyU) _adicionarLetra('U');
      else if (key == LogicalKeyboardKey.keyV) _adicionarLetra('V');
      else if (key == LogicalKeyboardKey.keyW) _adicionarLetra('W');
      else if (key == LogicalKeyboardKey.keyX) _adicionarLetra('X');
      else if (key == LogicalKeyboardKey.keyY) _adicionarLetra('Y');
      else if (key == LogicalKeyboardKey.keyZ) _adicionarLetra('Z');
      else if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
        _adicionarLetra('⌫');
      }
      else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        if (!jogoFinalizado && tentativas[tentativaAtual].join().length == 5) {
          _verificarPalavra();
        }
      }
    }
  }

  void _verificarPalavra() async {
    if (tentativas[tentativaAtual].contains('')) return;

    String palavraDigitada = tentativas[tentativaAtual].join();
    
    if (!WordValidator.isValidWord(palavraDigitada.toLowerCase())) {
      _mostrarMensagemErro("Palavra não existe!");
      return;
    }

    bool acertou = palavraDigitada == palavraAtual;
    await _registrarTentativa(acertou);

    List<bool> consumidas = List.filled(5, false);
    List<int> estadoAtual = List.filled(5, 0);

    for (int i = 0; i < 5; i++) {
      if (palavraDigitada[i] == palavraAtual[i]) {
        estadoAtual[i] = 2;
        consumidas[i] = true;
      }
    }

    for (int i = 0; i < 5; i++) {
      if (estadoAtual[i] == 2) continue;

      for (int j = 0; j < 5; j++) {
        if (!consumidas[j] && palavraDigitada[i] == palavraAtual[j]) {
          estadoAtual[i] = 1;
          consumidas[j] = true;
          break;
        }
      }

      if (estadoAtual[i] == 0) {
        estadoAtual[i] = -1;
      }
    }

    for (int i = 0; i < 5; i++) {
      final letra = tentativas[tentativaAtual][i];
      if (letra.isNotEmpty) {
        if (estadoAtual[i] == 2) {
          estadoLetrasTeclado[letra] = 2;
        } else if (estadoAtual[i] == 1) {
          if (estadoLetrasTeclado[letra] != 2) {
            estadoLetrasTeclado[letra] = 1;
          }
        } else if (estadoAtual[i] == -1) {
          if (estadoLetrasTeclado[letra] != 2 && estadoLetrasTeclado[letra] != 1) {
            estadoLetrasTeclado[letra] = -1;
          }
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

    await _salvarEstado();
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

  void _mostrarMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
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
        return Colors.grey[300]!;
    }
  }

  Color _getCorTeclado(String letra) {
    final estado = estadoLetrasTeclado[letra];
    
    if (estado == 2) {
      return Colors.green;
    } else if (estado == 1) {
      return Colors.yellow;
    } else if (estado == -1) {
      return Colors.red;
    } else {
      return const Color.fromARGB(255, 176, 175, 175);
    }
  }

  Widget _buildCaixa(double larguraDisponivel, int tentativa, int posicao, bool isTablet) {
    double tamanhoCaixa = isTablet ? larguraDisponivel / 11 : larguraDisponivel / 9;

    return GestureDetector(
      onTap: () => _selecionarPosicao(tentativa, posicao),
      child: Container(
        margin: const EdgeInsets.all(4),
        width: tamanhoCaixa,
        height: tamanhoCaixa,
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
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            tentativas[tentativa][posicao],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: estados[tentativa][posicao] == 0
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTecla(String letra, double larguraTela, bool isTablet) {
    double larguraTecla = isTablet ? larguraTela / 13 : larguraTela / 12;
    double alturaTecla = isTablet ? larguraTecla * 1.2 : larguraTecla * 1.3;
    
    return Container(
      margin: const EdgeInsets.all(2),
      width: larguraTecla,
      height: alturaTecla,
      child: ElevatedButton(
        onPressed: () => _adicionarLetra(letra),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: _getCorTeclado(letra),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            letra,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: isTablet ? 14 : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeclaBackspace(double larguraTela, bool isTablet) {
    double larguraTecla = isTablet ? larguraTela / 13 : larguraTela / 12;
    double alturaTecla = isTablet ? larguraTecla * 1.2 : larguraTecla * 1.3;
    
    return Container(
      margin: const EdgeInsets.all(2),
      width: larguraTecla,
      height: alturaTecla,
      child: ElevatedButton(
        onPressed: () => _adicionarLetra('⌫'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Icon(
          Icons.backspace,
          color: Colors.white,
          size: isTablet ? 18 : 20,
        ),
      ),
    );
  }

  Widget _buildLinhaTeclado(String letras, double larguraTela, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letras.split('').map((letra) => _buildTecla(letra, larguraTela, isTablet)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final limitedMediaQuery = mediaQuery.copyWith(
      textScaleFactor: mediaQuery.textScaleFactor.clamp(1.0, 1.3).toDouble(),
    );

    return MediaQuery(
      data: limitedMediaQuery,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double larguraTela = constraints.maxWidth;
                double alturaTela = constraints.maxHeight;
                bool isTablet = larguraTela > 600;
                double larguraMaxima = isTablet ? 500 : larguraTela;

                return KeyboardListener(
                  focusNode: _focusNode,
                  onKeyEvent: _handleKeyEvent,
                  child: SizedBox(
                    width: larguraMaxima,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            odsAtual['tema'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: List.generate(5, (tentativa) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (posicao) => _buildCaixa(larguraMaxima, tentativa, posicao, isTablet),
                                ),
                              );
                            }),
                          ),
                        ),

                        const Spacer(),

                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: SizedBox(
                            width: larguraMaxima * 0.4,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: !jogoFinalizado &&
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

                        Container(
                          padding: EdgeInsets.only(
                            bottom: isTablet ? 10 : alturaTela * 0.02,
                            left: isTablet ? 20 : 0,
                            right: isTablet ? 20 : 0,
                          ),
                          child: Column(
                            children: [
                              _buildLinhaTeclado('QWERTYUIOP', larguraMaxima, isTablet),
                              const SizedBox(height: 5),
                              _buildLinhaTeclado('ASDFGHJKL', larguraMaxima, isTablet),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...'ZXCVBNM'.split('').map((letra) => _buildTecla(letra, larguraMaxima, isTablet)),
                                  _buildTeclaBackspace(larguraMaxima, isTablet),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}