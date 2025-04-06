import 'package:flutter/material.dart';
import 'package:kicknplay_app/screens/home_page.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      backgroundColor: Colors.white, // Fondo limpio y elegante
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50), // Espaciado inicial

            // Logo
            Image.asset(
              'assets/k&plogo.jpg',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),

            // Título del Login
            Text(
              "Bienvenido a KicknPlay",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 30),

            // Campo de Usuario
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Color(0xFF0077FF)),
                filled: true,
                fillColor: Colors.grey[200], // Fondo sutil para el campo
              ),
            ),
            SizedBox(height: 16),

            // Campo de Contraseña
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Color(0xFF0077FF)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true, // Ocultar texto para la contraseña
            ),
            SizedBox(height: 30),

            // Botón de Iniciar Sesión
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0077FF), // Azul consistente
                        foregroundColor: Colors.white, // Texto blanco
                        padding:
                            EdgeInsets.symmetric(vertical: 15), // Botón grande
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
            SizedBox(height: 20),

            // Enlaces útiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navegar a Recuperar Contraseña
                  },
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: Color(0xFF0077FF)),
                  ),
                ),
                Text("|"),
                TextButton(
                  onPressed: () {
                    // Navegar a Registro
                  },
                  child: Text(
                    "Registrarse",
                    style: TextStyle(color: Color(0xFF0077FF)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40), // Espaciado al final
          ],
        ),
      ),
    );
  }
}
