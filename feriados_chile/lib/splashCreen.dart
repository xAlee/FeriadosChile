import 'package:flutter/material.dart';
import 'package:splashify/splashify.dart';
import 'package:feriados_chile/Home.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Splashify(
      imagePath: "assets/icons/image.png",
      imageSize: 550,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      navigateDuration: 2,
      child: const Home(title: 'Feriados Chile'),
    ));
  }
}
