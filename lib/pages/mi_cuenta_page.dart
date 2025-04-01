import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kicknplay_app/pages/cambiar_clave_page.dart';
import 'package:kicknplay_app/pages/editar_informacion_page.dart';

class MiCuentaPage extends StatefulWidget {
  @override
  _MiCuentaPageState createState() => _MiCuentaPageState();
}

class _MiCuentaPageState extends State<MiCuentaPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final String? token = await secureStorage.read(key: 'access_token');
    final String? username = await secureStorage.read(key: 'username');

    if (token == null || username == null) {
      throw Exception("No se encontró el token o username.");
    }

    final response = await http.post(
      Uri.parse(
          'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/obtener_usuario/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'username': username}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve la información del usuario
    } else {
      throw Exception("Error al obtener la información: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Cuenta"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final userInfo = snapshot.data!;
            return Padding(
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
                    subtitle: Text(userInfo['first_name'] ?? 'No disponible'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF0077FF)),
                    title: Text("Correo Electrónico"),
                    subtitle: Text(userInfo['email'] ?? 'No disponible'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF0077FF)),
                    title: Text("Teléfono"),
                    subtitle: Text(userInfo['user_profile']?['phone_number'] ??
                        'No disponible'),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarInformacionPage(userInfo: userInfo),
                            ),
                          );
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CambiarClavePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF8C00),
                          foregroundColor: Colors.white,
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
            );
          } else {
            return Center(child: Text("No hay datos disponibles."));
          }
        },
      ),
    );
  }
}
