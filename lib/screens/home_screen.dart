import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note que não há mais o Scaffold com AppBar aqui, apenas o conteúdo
    return const Center(
      child: Text('Jogando Agora', style: TextStyle(fontSize: 20)),
    );
  }
}
