import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Bestämma sig, svenska eller engelska?
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final name = _nameController.text.trim();
    final idNum = _idController.text.trim();
    bool isIOS = Platform.isIOS;

    if (name.isEmpty || idNum.isEmpty) {
      _showError('Båda fälten måste fyllas i');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final url = isIOS ? Uri.parse("http://localhost:8080/persons") : Uri.parse("http://10.0.2.2:8080/persons");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> persons = jsonDecode(response.body);

        final match = persons.firstWhere((p) => p['name'] == name && p['idNum'] == idNum, orElse: () => null,);
        if (match != null) {
          // Obvious success
          // Save in shared preferences library
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('loggedUser', name);
          await prefs.setString('loggedInUsereId', idNum);
          widget.onLoginSuccess();
          await Future.delayed(Duration(milliseconds: 300));
          return;

        } else {
          _showError('Incorrect username or ID');
        }
      }
      else {
        _showError('Unable to connect to the server');
      }
    } catch (e) {
      _showError('An issue appeared: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(context: context, builder: (_) => AlertDialog(
      // lol check spelling
      title: const Text('Login unsuccesful'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
      ],
    ));
  }

  void _showSuccess(String message) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Yay! Välkommen!'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
        )
      ],
    ));
  }

  void _showRegisterDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Välkommen att registrera ett nytt konto!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController,
          decoration: const InputDecoration(labelText: 'Namn'),
          ),
          TextField(controller: idController,
          decoration: const InputDecoration(labelText: 'ID-nummer'),),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Avbryt'),),
        ElevatedButton(onPressed: () async {
          final name = nameController.text.trim();
          final id = idController.text.trim();

          if (name.isEmpty || id.isEmpty) return;

          final response = await http.post(Uri.parse(Platform.isIOS ? 'http://localhost:8080/persons' : 'http:/10.0.2.2:8080/persons'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name, 'idNum': id}),
          );
          Navigator.pop(context);

          if (response.statusCode == 200) {
            _showSuccess('Du kan nu logga in på ditt nya konto');
          } else {
            _showError('Kunde inte skapa användare');
          }
        }, child: const Text('Skapa'),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return
          Center(
            child: ConstrainedBox(constraints: const BoxConstraints(
              maxWidth: 500
            ),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: SingleChildScrollView(child: Column(
            children: [
              const Text('Log in'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'User name'),
              ),
              TextFormField(controller: _idController, decoration: InputDecoration(labelText: 'ID number'), obscureText: true,),
              _isLoading ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _login, child: const Text('Log in')),
              TextButton(onPressed: _showRegisterDialog, child: Text('Skapa ny användare'))
            ],
                    ),),),),);
          }
      ),
      
    );
  }
}