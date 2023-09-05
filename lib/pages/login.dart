import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/usuario.dart';
import 'package:flutter_application_1/pages/partido_page.dart';
import 'package:flutter_application_1/providers/providers_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  final loginProvider = ProvidersServices();

  Future<void> login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    setState(() {
      _errorMessage = ''; // Restablecer el mensaje de error
    });

    try {
      SharedPreferences prefsUser = await SharedPreferences.getInstance();

      Usuario? result = await loginProvider.login(username, password);

      if (result != null) {
        await prefsUser.setString("username", result.nombre);
        await prefsUser.setInt("userId", result.id);

        BuildContext scaffoldContext = context;
        Navigator.pushAndRemoveUntil(
          scaffoldContext,
          MaterialPageRoute(
            builder: (context) => PartidoPage(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'Nombre de usuario o contraseña no válidos';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error en el servidor';
      });
      print("Error: $e"); // Imprime el error capturado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ticket Premium',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => login(context),
              child: const Text('Iniciar sesión'),
            ),
            const SizedBox(height: 8.0),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
