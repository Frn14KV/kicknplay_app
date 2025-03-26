import 'package:flutter/material.dart';
import 'package:kicknplay_app/main.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService(); // Servicio de autenticación
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading =
      false; // Indicador de carga para evitar múltiples solicitudes

  // Método para manejar el inicio de sesión
  void _login() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      // Llama al servicio de autenticación para iniciar sesión
      await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );
      // Recupera el token desde el servicio
      final accessToken = await _authService.getAccessToken();

      // Almacena el token en almacenamiento seguro
      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: 'access_token', value: accessToken);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inicio de sesión exitoso"),
      ));

      // Navegar a la pantalla principal (HomePage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Manejar error de inicio de sesión
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenido",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Usuario"),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator()) // Indicador de carga
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text("Iniciar Sesión"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
