import 'dart:async';
import 'package:flutter/services.dart';

class WordValidator {
  static List<String> _wordBank = [];
  static bool _isLoaded = false;

  static String _normalizarTexto(String texto) {
  return texto
      .toUpperCase()
      .replaceAll(RegExp(r'[ÁÀÂÃ]'), 'A')
      .replaceAll(RegExp(r'[ÉÈÊ]'), 'E')
      .replaceAll(RegExp(r'[ÍÌÎ]'), 'I')
      .replaceAll(RegExp(r'[ÓÒÔÕ]'), 'O')
      .replaceAll(RegExp(r'[ÚÙÛ]'), 'U')
      .replaceAll('Ç', 'C')
      .replaceAll('Ñ', 'N')
      .replaceAll(RegExp(r'[^A-Z]'), '');
}

  static Future<void> loadWordBank() async {
    if (_isLoaded) return;
    
    try {
      final String contents = await rootBundle.loadString('assets/palavras5.txt');
      
      _wordBank = contents.split('\n')
          .map((word) => word.trim())
          .where((word) => word.isNotEmpty)
          .map((word) => _normalizarTexto(word))
          .toList();
      
      _wordBank.sort(); // Ordena para busca binária
      _isLoaded = true;
      
      print('Banco de palavras carregado: ${_wordBank.length} palavras');
      print('Primeiras 10 palavras: ${_wordBank.take(10).toList()}');
      
    } catch (e) {
      print('Erro ao carregar banco de palavras: $e');
      _wordBank = [
        'AJUDA', 'RENDA', 'MORAR', 'DIGNO', 'ACOES', 'HORTA', 'FRUTA', 'GRAMA', 
        'FOLHA', 'GRAOS', 'SAUDE', 'IMUNE', 'CURAS', 'CORPO', 'MENTE', 'LIVRO',
        'SABER', 'LICAO', 'AULAS', 'PAPEL', 'LUTAR', 'FORCA', 'APOIO', 'VOZES',
        'VALOR', 'LIMPO', 'CHUVA', 'BANHO', 'LAVAR', 'CANAL', 'VENTO', 'SOLAR',
        'LUZES', 'FONTE', 'CALOR', 'VENDA', 'LUCRO', 'CONTA', 'SETOR', 'BANCO',
        'PONTE', 'FERRO', 'TORRE', 'OBRAS', 'USINA', 'LACOS', 'NORMA', 'ETNIA',
        'RACAS', 'IGUAL', 'PRACA', 'CASAS', 'CORES', 'LUGAR', 'LAZER', 'REUSO',
        'CICLO', 'ETAPA', 'RESTO', 'TERRA', 'CLIMA', 'RISCO', 'GLOBO', 'SECAS',
        'GASES', 'PEIXE', 'MARES', 'ACUDE', 'ALGAS', 'ONDAS', 'FLORA', 'FAUNA',
        'BICHO', 'SERES', 'VIDAS', 'JUSTO', 'NACAO', 'ETICA', 'REGRA', 'ORDEM',
        'UNIAO', 'JUNTO', 'GRUPO', 'PACTO', 'MEIOS'
      ].map((word) => _normalizarTexto(word)).toList();
      
      _wordBank.sort();
      _isLoaded = true;
    }
  }

  static bool isValidWord(String word) {
  if (!_isLoaded) {
    print('Banco de palavras não carregado ainda');
    return false;
  }
  
  String normalizada = _normalizarTexto(word);
  

  if (_buscaBinaria(normalizada)) {
    return true;
  }
  
  List<String> variantes = _gerarVariantesAcentuadas(normalizada);
  for (String variante in variantes) {
    if (_buscaBinaria(variante)) {
      return true;
    }
  }
  
  return false;
}

static bool _buscaBinaria(String palavra) {
  int inicio = 0;
  int fim = _wordBank.length - 1;
  
  while (inicio <= fim) {
    int meio = (inicio + fim) ~/ 2;
    int comparacao = _wordBank[meio].compareTo(palavra);
    
    if (comparacao == 0) {
      return true;
    } else if (comparacao < 0) {
      inicio = meio + 1;
    } else {
      fim = meio - 1;
    }
  }
  return false;
}

static List<String> _gerarVariantesAcentuadas(String palavra) {
  List<String> variantes = [];
  
  if (palavra.endsWith('CAO')) {
    variantes.add(palavra.substring(0, palavra.length - 3) + 'ÇÃO');
  }
  
  return variantes;
}
}