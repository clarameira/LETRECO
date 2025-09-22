import 'package:flutter/material.dart';
import 'home.dart';
import 'services/word_validator.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await WordValidator.loadWordBank();
  
  runApp(const LetrecoApp());
}

class LetrecoApp extends StatelessWidget {
  const LetrecoApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LetrecoHome(),
    );
  }
}
