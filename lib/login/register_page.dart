import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? message;

  Future<void> _register() async {
    setState(() => message = null);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'name': nameController.text.trim(), 'email': emailController.text.trim()});

      setState(() => message = 'Cadastro realizado com sucesso!');

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            message = 'E-mail já está em uso.';
            break;
          case 'weak-password':
            message = 'A senha é muito fraca.';
            break;
          default:
            message = 'Erro ao cadastrar: ${e.message}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Cadastrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text('Cadastrar')),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: TextStyle(color: message!.contains('sucesso') ? Colors.green : Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}