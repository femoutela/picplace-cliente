import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();

  List<dynamic> _addressResults = [];
  bool _isSaving = false;

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) {
      setState(() => _addressResults = []);
      return;
    }

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1',
    );

    final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});

    if (response.statusCode == 200) {
      setState(() => _addressResults = json.decode(response.body));
    } else {
      setState(() => _addressResults = []);
    }
  }

  Future<void> _onSave() async {
    if (_formKey.currentState?.validate() != true) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não está logado!')),
      );
      return;
    }

    final uid = user.uid;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final priceText = _priceController.text.trim().replaceAll(',', '.');
    final price = double.tryParse(priceText) ?? 0;
    final address = _addressController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, escolha um endereço válido')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('imoveis').add({
        'uid': uid,
        'titulo': title,
        'descricao': description,
        'preco': price,
        'endereco': address,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imóvel salvo com sucesso!')),
      );

      _formKey.currentState?.reset();
      setState(() => _addressResults = []);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar imóvel: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Cadastrar Imóvel'),
      backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título do imóvel',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
                  final value = double.tryParse(v.replaceAll(',', '.'));
                  if (value == null || value <= 0) return 'Preço inválido';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
                onChanged: _searchAddress,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              if (_addressResults.isNotEmpty) ...[
                SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                    itemCount: _addressResults.length,
                    itemBuilder: (_, i) {
                      final item = _addressResults[i];
                      return ListTile(
                        title: Text(item['display_name']),
                        onTap: () {
                          _addressController.text = item['display_name'];
                          setState(() => _addressResults = []);
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 20),
              _isSaving
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _onSave,
                      child: Text('Salvar imóvel'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
