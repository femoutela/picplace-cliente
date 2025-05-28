import 'package:flutter/material.dart';

class RunningScreen extends StatelessWidget {
  const RunningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco.
      body: Center(
        child: Text(
          'Running Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
