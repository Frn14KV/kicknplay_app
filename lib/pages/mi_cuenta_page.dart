import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kicknplay_app/pages/cambiar_clave_page.dart';
import 'package:kicknplay_app/pages/editar_informacion_page.dart';

class MiCuentaPage extends StatefulWidget {
  const MiCuentaPage({super.key});

  @override
  _MiCuentaPageState createState() => _MiCuentaPageState();
}

class _MiCuentaPageState extends State<MiCuentaPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String userImage =
      'https://via.placeholder.com/150'; // URL de imagen de perfil
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(); // Cargar datos al inicio
  }

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

  void refreshUserInfo() {
    setState(() {
      _userInfoFuture = fetchUserInfo(); // Recargar datos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Cuenta",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF0077FF), // Azul, como estaba antes
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
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
                children: [
                  // Imagen de perfil
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/k&plogo.jpg'), // Ruta del logo en assets
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(height: 20),

                  // Saludo personalizado
                  Text(
                    "¡Hola, ${userInfo['first_name']}!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),

                  // Tarjetas de información
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            leading:
                                Icon(Icons.person, color: Color(0xFF0077FF)),
                            title: Text("Nombre"),
                            subtitle: Text(
                                "${userInfo['first_name']} ${userInfo['last_name']}"),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            leading:
                                Icon(Icons.email, color: Color(0xFF0077FF)),
                            title: Text("Correo Electrónico"),
                            subtitle: Text(userInfo['email']),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            leading:
                                Icon(Icons.phone, color: Color(0xFF0077FF)),
                            title: Text("Teléfono"),
                            subtitle:
                                Text(userInfo['user_profile']['phone_number']),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(Icons.location_on,
                                color: Color(0xFF0077FF)),
                            title: Text("Ubicación"),
                            subtitle:
                                Text(userInfo['user_profile']['location']),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(Icons.info, color: Color(0xFF0077FF)),
                            title: Text("Bio"),
                            subtitle: Text(userInfo['user_profile']['bio']),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botones interactivos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Navegar a la pantalla de edición y esperar los datos actualizados
                          final updatedUserInfo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarInformacionPage(userInfo: userInfo),
                            ),
                          );

                          // Refrescar datos si se reciben actualizaciones
                          if (updatedUserInfo != null) {
                            setState(() {
                              _userInfoFuture = Future.value(updatedUserInfo);
                            });
                          }
                        },
                        icon: Icon(Icons.edit,
                            color: Colors.white), // Agrega el icono al botón
                        label: Text("Editar Información"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CambiarClavePage()),
                          );
                        },
                        icon: Icon(Icons.lock),
                        label: Text("Cambiar Clave"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF8C00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
