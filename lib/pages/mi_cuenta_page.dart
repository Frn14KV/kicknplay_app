import 'package:flutter/material.dart';

class MiCuentaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Cuenta"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Información de Usuario",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077FF),
              ),
            ),
            SizedBox(height: 20),
            // Detalles del usuario
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF0077FF)),
              title: Text("Nombre"),
              subtitle: Text("Juan Pérez"),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFF0077FF)),
              title: Text("Correo Electrónico"),
              subtitle: Text("juan.perez@example.com"),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xFF0077FF)),
              title: Text("Teléfono"),
              subtitle: Text("+123 456 7890"),
            ),
            SizedBox(height: 30),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la página de editar información
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarInformacionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF0077FF), // Azul para consistencia
                    foregroundColor: Colors.white, // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Editar Información"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la página de cambiar clave
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambiarClavePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF8C00), // Naranja para acción
                    foregroundColor: Colors.white, // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Cambiar Clave"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Página temporal para "Editar Información"
class EditarInformacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Información"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Center(
        child: Text(
          "Aquí puedes editar tu información.",
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ),
    );
  }
}

// Página temporal para "Cambiar Clave"
class CambiarClavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar Clave"),
        backgroundColor: Color(0xFFFF8C00),
      ),
      body: Center(
        child: Text(
          "Aquí puedes cambiar tu clave.",
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
