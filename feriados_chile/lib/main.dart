import 'package:feriados_chile/splashCreen.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(SplashScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feriados en Chile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(title: 'Feriados Chile'),
    );
  }
}
