import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _imagem;

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();

    final XFile? imagemSelecionada = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.grey),
              title: const Text(
                "Escolher da galeria",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final imagem = await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, imagem);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.grey),
              title: const Text(
                "Tirar foto",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                final foto = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, foto);
              },
            ),
          ],
        );
      },
    );

    if (imagemSelecionada != null) {
      setState(() {
        _imagem = File(imagemSelecionada.path);
      });
    }
  }

  Future<void> _register() async {
    setState(() => message = null);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final uid = userCredential.user!.uid;

      String? fotoUrl;
      if (_imagem != null) {
        final storageRef = FirebaseStorage.instance.ref().child('fotos_perfil/$uid.jpg');
        await storageRef.putFile(_imagem!);
        fotoUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'fotoUrl': fotoUrl ?? '',
      });

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

  OutlineInputBorder _roundedBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Cadastrar Usuário'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selecionarImagem,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300], // fundo cinza claro
                backgroundImage: _imagem != null ? FileImage(_imagem!) : null,
                child: _imagem == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[700]) // ícone cinza escuro
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: _roundedBorder(Colors.grey),
                focusedBorder: _roundedBorder(Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: _roundedBorder(Colors.grey),
                focusedBorder: _roundedBorder(Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: _roundedBorder(Colors.grey),
                focusedBorder: _roundedBorder(Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Cadastrar'),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  color: message!.contains('sucesso') ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
