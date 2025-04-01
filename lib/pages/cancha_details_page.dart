import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kicknplay_app/pages/reservar_cancha_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CanchaDetailsPage extends StatefulWidget {
  final Map<String, dynamic> cancha;

  const CanchaDetailsPage({Key? key, required this.cancha}) : super(key: key);

  @override
  _CanchaDetailsPageState createState() => _CanchaDetailsPageState();
}

class _CanchaDetailsPageState extends State<CanchaDetailsPage> {
  int _comentariosMostrados = 6; // Número inicial de comentarios mostrados
  final TextEditingController _commentController = TextEditingController();
  double _newRating = 0.0; // Calificación dada por el usuario

  // Método para cargar más comentarios
  void _cargarMasComentarios() {
    setState(() {
      _comentariosMostrados +=
          6; // Incrementa los comentarios mostrados en lotes de 6
    });
  }

  // Método para abrir Google Maps con la dirección
  void _openMaps(BuildContext context) async {
    final latitud = widget.cancha['latitud'];
    final longitud = widget.cancha['longitud'];
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitud,$longitud";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo abrir Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final comentarios = widget.cancha['comentarios'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cancha['nombre'] ?? "Detalles de la Cancha",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen destacada
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: widget.cancha['imagen_url'] != null
                  ? Image.network(
                      widget.cancha['imagen_url'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/k&plogo.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 20),

            // Título de la cancha
            Center(
              child: Text(
                widget.cancha['nombre'] ?? "Sin nombre",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),

            // Dirección y capacidad
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.cancha['direccion'] ?? "Dirección no disponible",
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.people, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Capacidad: ${widget.cancha['capacidad'] ?? "No especificada"} personas",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 20),

            Divider(color: Colors.grey[300], thickness: 1),

            // Botones "Reservar" y "Ver Dirección"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final FlutterSecureStorage secureStorage =
                          FlutterSecureStorage();

                      // 1. Recuperar el username desde FlutterSecureStorage
                      final String? username =
                          await secureStorage.read(key: 'username');
                      if (username == null) {
                        throw Exception(
                            "No se encontró el username. Por favor inicia sesión primero.");
                      }

                      // 2. Llamar al API para obtener el usuario por username
                      final String? token = await secureStorage.read(
                          key:
                              'access_token'); // Recupera el token desde FlutterSecureStorage
                      if (token == null) {
                        throw Exception(
                            "No se encontró el token. Por favor inicia sesión primero.");
                      }

                      final response = await http.post(
                        Uri.parse(
                            'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/obtener_usuario/'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization':
                              'Bearer $token', // Incluye el token en los headers
                        },
                        body: json.encode({'username': username}),
                      );

                      if (response.statusCode != 200) {
                        throw Exception(
                            "Error al obtener la información del usuario: ${response.body}");
                      }

                      final data = json.decode(response.body);
                      final int usuarioId = data[
                          'id']; // Extraer el ID del usuario desde la respuesta

                      // 3. Navegar a la pantalla de reserva con el ID del usuario
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservarCanchaPage(
                            cancha: widget.cancha, // Información de la cancha
                            usuarioId:
                                usuarioId, // ID dinámico del usuario obtenido del API
                          ),
                        ),
                      );
                    } catch (e) {
                      // Manejo de errores
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text("Reservar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openMaps(context),
                  icon: Icon(Icons.map),
                  label: Text("Ver Dirección"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Divider(color: Colors.grey[300], thickness: 1),

            // Comentarios
            Text(
              "Comentarios",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Muestra comentarios en lotes
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (_comentariosMostrados < comentarios.length)
                  ? _comentariosMostrados
                  : comentarios.length,
              itemBuilder: (context, index) {
                final comentario = comentarios[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shadowColor: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                comentario['user'] != null
                                    ? comentario['user'][0].toUpperCase()
                                    : "?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              comentario['user'] ?? "Usuario desconocido",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        RatingBarIndicator(
                          rating: comentario['calificacion']?.toDouble() ?? 0.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                        ),
                        SizedBox(height: 5),
                        Text(
                          comentario['texto'] ?? "Comentario no disponible",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Botón "Cargar más comentarios"
            if (_comentariosMostrados < comentarios.length)
              Center(
                child: TextButton(
                  onPressed: _cargarMasComentarios,
                  child: Text(
                    "Cargar más comentarios",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (comentarios.isEmpty)
              Text(
                "Aún no hay comentarios sobre esta cancha.",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),

            SizedBox(height: 20),

            Divider(color: Colors.grey[300], thickness: 1),

            // Sección para agregar un nuevo comentario
            Text(
              "Deja tu comentario",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Escribe tu comentario aquí...",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Calificación: ",
                  style: TextStyle(fontSize: 16),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _newRating = rating;
                    });
                  },
                  itemSize: 30,
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final comentario = _commentController.text;
                  if (comentario.isNotEmpty && _newRating > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Tu comentario fue enviado con una calificación de $_newRating estrellas.",
                        ),
                      ),
                    );
                    _commentController.clear(); // Limpia el campo de texto
                    setState(() {
                      _newRating = 0.0; // Reinicia la calificación
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Por favor, ingresa un comentario y calificación",
                        ),
                      ),
                    );
                  }
                },
                child: Text("Enviar Comentario"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
