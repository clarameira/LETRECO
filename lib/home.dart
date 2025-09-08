import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tela1.dart';

class LetrecoHome extends StatelessWidget {
  const LetrecoHome({super.key});

  Future<bool> _podeJogarHoje() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now().toString().split(' ')[0];
    final ultimaData = prefs.getString('ultimaDataJogo');
    return ultimaData != hoje;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Letreco',
              style: TextStyle(
                fontSize: 40,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bungee',
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Como jogar:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildLegenda(Colors.green, 'Letra certa na posição certa'),
                  const SizedBox(height: 10),
                  _buildLegenda(Colors.yellow, 'Letra certa na posição errada'),
                  const SizedBox(height: 10),
                  _buildLegenda(Colors.red, 'Letra errada, não existe na palavra'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (await _podeJogarHoje()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaBranca()),
                  );
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  final hoje = DateTime.now().toString().split(' ')[0];
                  final resultado = prefs.getString('resultado$hoje') ?? 'jogou';
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        resultado == 'venceu' 
                            ? 'Você já venceu hoje! Volte amanhã.'
                            : 'Você já jogou hoje! Tente novamente amanhã.',
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text(
                'INICIAR',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegenda(Color color, String texto) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
