import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'editar_informacion_page.dart'; // Asegúrate de que la ruta sea correcta

class MiCuentaPage extends StatefulWidget {
  @override
  _MiCuentaPageState createState() => _MiCuentaPageState();
}

class _MiCuentaPageState extends State<MiCuentaPage> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      // Recuperar el token desde FlutterSecureStorage
      final secureStorage = FlutterSecureStorage();
      final String? token = await secureStorage.read(key: 'access_token');

      if (token == null) {
        throw Exception(
            "No se encontró el token. Por favor inicia sesión nuevamente.");
      }

      // Realizar la solicitud al backend para obtener la información del usuario
      final response = await http.post(
        Uri.parse(
            'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/obtener_usuario/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userInfo =
              json.decode(response.body); // Guardar la información del usuario
        });
      } else {
        throw Exception("Error al cargar los datos: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Cuenta"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: userInfo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xFF0077FF)),
                    title: Text("Nombre"),
                    subtitle: Text(userInfo!['first_name']),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.person_outline, color: Color(0xFF0077FF)),
                    title: Text("Apellido"),
                    subtitle: Text(userInfo!['last_name']),
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Color(0xFF0077FF)),
                    title: Text("Bio"),
                    subtitle: Text(userInfo!['user_profile']['bio']),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF0077FF)),
                    title: Text("Teléfono"),
                    subtitle: Text(userInfo!['user_profile']['phone_number']),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Color(0xFF0077FF)),
                    title: Text("Ubicación"),
                    subtitle: Text(userInfo!['user_profile']['location']),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Navegar a la pantalla de edición y esperar los datos actualizados
                          final updatedUserInfo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarInformacionPage(userInfo: userInfo!),
                            ),
                          );

                          // Actualizar los datos en la pantalla si se reciben datos nuevos
                          if (updatedUserInfo != null) {
                            setState(() {
                              userInfo = updatedUserInfo;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Editar Información"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final secureStorage = FlutterSecureStorage();
                            await secureStorage.delete(key: 'access_token');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Cierre de sesión exitoso")),
                            );
                            Navigator.of(context).popUntil(
                                (route) => route.isFirst); // Volver al inicio
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Error al cerrar sesión: ${e.toString()}")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Cerrar Sesión"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
