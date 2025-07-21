import 'package:flutter/material.dart';

class TelaBranca extends StatefulWidget {
  const TelaBranca({super.key});

  @override
  State<TelaBranca> createState() => _TelaBrancaState();
}

class _TelaBrancaState extends State<TelaBranca> {
  List<String> letras = ['', '', '', '', '']; // Caixinhas vazias
  int posicaoSelecionada = 0; // Qual caixinha foi clicada

  void adicionarLetra(String letra) {
    setState(() {
      letras[posicaoSelecionada] = letra;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('letreco'),
        backgroundColor: Colors.green,
      ),
     body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
                    'letreco',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text( 
                   'tema',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    'erradicação da pobreza',
                  ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    posicaoSelecionada = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: posicaoSelecionada == index
                        ? Colors.green
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letras[index],
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 200),
          Center(
           child: Wrap(
             spacing: 10,
             runSpacing: 10,
             alignment: WrapAlignment.center,
             children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letra) {
               return SizedBox(
                 height: 45,
                 width: 45,
                 child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
            alignment: Alignment.center, // já centraliza o conteúdo
            backgroundColor: const Color.fromARGB(255, 176, 175, 175),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.zero, // remove espaços extras
          ),
                   onPressed: () => adicionarLetra(letra),
                   child: Text(
                     letra,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                       color: Colors.white,
                      ),
                   ),
                 ),
               );
             }).toList(),
           ),
          ),
            
        ],
      ),  
      
    );
  }
}