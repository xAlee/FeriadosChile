import 'package:flutter/material.dart';

class Feriadospage extends StatelessWidget {
  const Feriadospage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feriados 2024'),
      ),
      body: const Center(
        child: Text(
          'Lista de feriados de 2024 aquí.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
