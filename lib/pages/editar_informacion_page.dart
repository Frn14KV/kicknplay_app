import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditarInformacionPage extends StatefulWidget {
  final Map<String, dynamic> userInfo; // Información del usuario proporcionada

  EditarInformacionPage({required this.userInfo});

  @override
  _EditarInformacionPageState createState() => _EditarInformacionPageState();
}

class _EditarInformacionPageState extends State<EditarInformacionPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(); // Controlador para ubicación

  @override
  void initState() {
    super.initState();

    // Prellenar los controladores con la información actual del usuario
    nombreController.text = widget.userInfo['first_name'] ?? '';
    apellidoController.text = widget.userInfo['last_name'] ?? '';
    bioController.text = widget.userInfo['user_profile']?['bio'] ?? '';
    telefonoController.text =
        widget.userInfo['user_profile']?['phone_number'] ?? '';
    locationController.text = widget.userInfo['user_profile']?['location'] ??
        ''; // Prellenar ubicación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Información"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: apellidoController,
              decoration: InputDecoration(labelText: "Apellido"),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: "Bio"),
            ),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: "Teléfono"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: locationController, // Campo para ubicación
              decoration: InputDecoration(labelText: "Ubicación"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Recuperar el token de almacenamiento seguro
                  final secureStorage = FlutterSecureStorage();
                  final String? token =
                      await secureStorage.read(key: 'access_token');

                  if (token == null) {
                    throw Exception(
                        "No se encontró el token. Por favor inicia sesión nuevamente.");
                  }

                  // Enviar datos actualizados al backend
                  final response = await http.put(
                    Uri.parse(
                        'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/actualizar_usuario/'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization':
                          'Bearer $token', // Token de autenticación
                    },
                    body: json.encode({
                      'first_name': nombreController.text,
                      'last_name': apellidoController.text,
                      'bio': bioController.text,
                      'phone_number': telefonoController.text,
                      'location': locationController
                          .text, // Incluir ubicación en la solicitud
                    }),
                  );

                  if (response.statusCode == 200) {
                    final updatedUserInfo = json.decode(response.body)['user'];

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Información actualizada exitosamente")),
                    );

                    // Enviar los datos actualizados de regreso a la pantalla anterior
                    Navigator.pop(context, updatedUserInfo);
                  } else {
                    throw Exception(
                        "Error al actualizar la información: ${response.body}");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077FF),
                foregroundColor: Colors.white,
              ),
              child: Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
