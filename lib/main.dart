import 'package:flutter/material.dart';
import 'home.dart';
import 'services/word_validator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega o banco de palavras antes de iniciar o app
  await WordValidator.loadWordBank();
  
  runApp(const LetrecoApp());
}

class LetrecoApp extends StatelessWidget {
  const LetrecoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LetrecoHome(),
    );
  }
}
