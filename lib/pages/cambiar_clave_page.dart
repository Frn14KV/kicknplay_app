import 'package:flutter/material.dart';

class CambiarClavePage extends StatefulWidget {
  @override
  _CambiarClavePageState createState() => _CambiarClavePageState();
}

class _CambiarClavePageState extends State<CambiarClavePage> {
  final TextEditingController claveActualController = TextEditingController();
  final TextEditingController claveNuevaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar Clave"),
        backgroundColor: Color(0xFFFF8C00), // Naranja de tu diseño
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: claveActualController,
              decoration: InputDecoration(labelText: "Contraseña Actual"),
              obscureText: true, // Para ocultar la entrada del texto
            ),
            TextField(
              controller: claveNuevaController,
              decoration: InputDecoration(labelText: "Nueva Contraseña"),
              obscureText: true, // Para ocultar la entrada del texto
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Simular cambio de contraseña en el backend
                  await Future.delayed(Duration(
                      seconds: 2)); // Simulación de solicitud al servidor
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contraseña cambiada exitosamente")),
                  );
                  Navigator.pop(context); // Volver a la pantalla anterior
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8C00), // Naranja
                foregroundColor: Colors.white, // Texto blanco
              ),
              child: Text("Cambiar Clave"),
            ),
          ],
        ),
      ),
    );
  }
}
