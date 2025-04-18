import 'package:flutter/material.dart';
import 'package:kicknplay_app/screens/home_page.dart';
import 'package:kicknplay_app/screens/registro_page.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService(); // Servicio de autenticación
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Llave del formulario
  bool _isLoading = false; // Indicador de carga

  // Método para manejar el inicio de sesión
  void _login() async {
    if (!_formKey.currentState!.validate()) {
      // Si los campos no son válidos, detener el proceso
      return;
    }

    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      // Intento de inicio de sesión
      await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );

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
        content: Text("Usuario o clave incorrectos"),
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
      body: Stack(
        children: [
          // Fondo con degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0077FF), Color(0xFF83C5BE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido principal
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Form(
              key: _formKey, // Asigna el formulario a la llave
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/k&plogo.jpg',
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 20),

                  // Título
                  Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Campo de Usuario
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu usuario";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Campo de Contraseña
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    obscureText: true, // Ocultar el texto
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingresa tu contraseña";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  // Botón de Iniciar Sesión
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white))
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0077FF),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Iniciar Sesión",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                  SizedBox(height: 16),

                  // Botón para registrarse
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistroPage()),
                      );
                    },
                    child: Text(
                      "¿No tienes cuenta? Registrarse",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
