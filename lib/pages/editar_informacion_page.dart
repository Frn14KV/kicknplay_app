import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditarInformacionPage extends StatefulWidget {
  final Map<String, dynamic> userInfo; // Información actual del usuario

  const EditarInformacionPage({super.key, required this.userInfo});

  @override
  _EditarInformacionPageState createState() => _EditarInformacionPageState();
}

class _EditarInformacionPageState extends State<EditarInformacionPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool isLoading = false; // Indicador de carga

  @override
  void initState() {
    super.initState();

    // Prellenar los controladores con la información actual del usuario
    nombreController.text = widget.userInfo['first_name'] ?? '';
    apellidoController.text = widget.userInfo['last_name'] ?? '';
    bioController.text = widget.userInfo['user_profile']?['bio'] ?? '';
    telefonoController.text =
        widget.userInfo['user_profile']?['phone_number'] ?? '';
    locationController.text =
        widget.userInfo['user_profile']?['location'] ?? '';
  }

  Future<void> saveChanges() async {
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Por favor, completa todos los campos obligatorios.")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true; // Mostrar indicador de carga
      });

      final secureStorage = FlutterSecureStorage();
      final String? token = await secureStorage.read(key: 'access_token');

      if (token == null) {
        throw Exception(
            "No se encontró el token. Por favor inicia sesión nuevamente.");
      }

      final response = await http.put(
        Uri.parse(
            'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/actualizar_usuario/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'first_name': nombreController.text,
          'last_name': apellidoController.text,
          'bio': bioController.text,
          'phone_number': telefonoController.text,
          'location': locationController.text,
        }),
      );

      setState(() {
        isLoading = false; // Ocultar indicador de carga
      });

      if (response.statusCode == 200) {
        final updatedUserInfo = json.decode(response.body)['user'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Información actualizada exitosamente")),
        );

        Navigator.pop(
            context, updatedUserInfo); // Regresar datos a la pantalla anterior
      } else {
        throw Exception("Error al actualizar la información: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Ocultar indicador de carga
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Información"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Encabezado
                  Text(
                    "Actualiza tu Información",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Campos de entrada en tarjetas
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: nombreController,
                        decoration: InputDecoration(labelText: "Nombre *"),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: apellidoController,
                        decoration: InputDecoration(labelText: "Apellido *"),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: bioController,
                        decoration: InputDecoration(labelText: "Bio"),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: telefonoController,
                        decoration: InputDecoration(labelText: "Teléfono *"),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(labelText: "Ubicación"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Botón de guardar cambios
                  ElevatedButton.icon(
                    onPressed: saveChanges,
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text("Guardar Cambios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
