import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // Pantalla principal HomePage
import 'screens/login_page.dart'; // Pantalla de inicio de sesión
import 'pages/map_page.dart'; // Pantalla del mapa
import 'pages/reservas_page.dart'; // Pantalla de reservas
import 'pages/canchas_page.dart'; // Pantalla de canchas
import 'pages/eventos_page.dart'; // Pantalla de canchas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ocultar el banner de debug
      title: 'KicknPlay', // Título de la app
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal
        scaffoldBackgroundColor: Colors.grey[200], // Fondo claro
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent, // Color del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Botones redondeados
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blue, // Fondo del BottomNavigationBar
          selectedItemColor: Colors.yellowAccent, // Color del ítem seleccionado
          unselectedItemColor: Colors.white, // Color de ítems no seleccionados
        ),
      ),
      // Pantalla inicial de la app
      initialRoute: '/login', // Rutas iniciales
      routes: {
        '/login': (context) => LoginPage(), // Ruta para LoginPage
        '/home': (context) => HomePage(), // Ruta para HomePage
        '/map': (context) => MapPage(), // Ruta para MapPage
        '/reservas': (context) => ReservasPage(), // Ruta para ReservasPage
        '/canchas': (context) => CanchasPage(), // Ruta para CanchasPage
        '/eventos': (context) => EventosPage(),
      },
    );
  }
}
