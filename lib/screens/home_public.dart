import 'package:flutter/material.dart';
import 'package:kicknplay_app/pages/canchas_page.dart';
import 'package:kicknplay_app/pages/eventos_page.dart';
import 'package:kicknplay_app/pages/map_page.dart';
import 'package:kicknplay_app/screens/login_page.dart'; // Importa la pantalla de login

class PublicHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a KicknPlay"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Introducción
            Text(
              "¿Qué es KicknPlay?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "KicknPlay es tu compañero ideal para encontrar, organizar y reservar canchas deportivas, participar en eventos públicos y disfrutar de una experiencia sencilla.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // Mapa Público
            Text(
              "Explora Canchas en el Mapa",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapPage()), // Navega al mapa
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077FF),
                foregroundColor: Colors.white,
              ),
              child: Text("Ver Mapa"),
            ),
            SizedBox(height: 20),

            // Lista de Canchas
            Text(
              "Explora Canchas Disponibles",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CanchasPage()), // Navega a las canchas
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077FF),
                foregroundColor: Colors.white,
              ),
              child: Text("Explorar Canchas"),
            ),
            SizedBox(height: 20),

            // Lista de Eventos Públicos
            Text(
              "Eventos Públicos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EventosPage()), // Navega a los eventos
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077FF),
                foregroundColor: Colors.white,
              ),
              child: Text("Ver Eventos Públicos"),
            ),
            SizedBox(height: 20),

            // Botón de Login
            Text(
              "¿Ya tienes cuenta?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()), // Navega al login
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Iniciar Sesión",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
