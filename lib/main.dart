import 'package:flutter/material.dart';
import 'pages/canchas_page.dart';
import 'screens/login_page.dart';
import 'pages/map_page.dart';
import 'pages/reservas_page.dart'; // Importa la pantalla de reservas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KicknPlay',
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal
        scaffoldBackgroundColor: Colors.grey[200], // Fondo claro
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent, // Color del texto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Botones redondeados
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.yellowAccent,
          unselectedItemColor: Colors.white,
        ),
      ),

      home: LoginPage(), // Inicia en la pantalla de inicio de sesión
    );
  }
}

// Pantalla principal después del inicio de sesión
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Lista de pantallas dentro del BottomNavigationBar
  final List<Widget> _screens = [
    // Pantalla de Inicio con el logo y el texto
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/k&plogo.jpg',
            width: 150, // Ajusta el tamaño del logo
            height: 150,
          ),
          SizedBox(height: 20), // Espaciado entre el logo y el texto
          Text(
            '¡Bienvenido a KicknPlay!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    // Pantalla de Mapa
    MapPage(),
    // Pantalla de Reservas
    ReservasPage(), // Integra tu pantalla dinámica de reservas
    CanchasPage(), // Nueva pantalla para mostrar las canchas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KicknPlay'),
      ),
      body: _screens[
          _currentIndex], // Cambia el cuerpo dinámicamente según el índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Controla la selección actual
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice seleccionado
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Canchas', // Nueva opción para las canchas
          ),
        ],
        selectedItemColor: Colors.blue, // Color del ítem seleccionado
        unselectedItemColor:
            Colors.white, // Color de los ítems no seleccionados
      ),
    );
  }
}
