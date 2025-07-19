import 'package:flutter/material.dart';
import 'home.dart';

void main() {
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


