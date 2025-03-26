import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart'; // Necesario para abrir enlaces

class CanchaDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cancha;

  const CanchaDetailsPage({Key? key, required this.cancha}) : super(key: key);

  // Método para abrir Google Maps con la dirección
  void _openMaps(BuildContext context) async {
    final latitud = cancha['latitud'];
    final longitud = cancha['longitud'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(cancha['nombre'] ?? "Detalles de la Cancha"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen destacada o logo predeterminado
            if (cancha['imagen_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  cancha['imagen_url'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/k&plogo.jpg', // Ruta de tu logo en los assets
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 20),
            // Nombre de la cancha
            Text(
              cancha['nombre'] ?? "Sin nombre",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 10),
            // Dirección
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    cancha['direccion'] ?? "Dirección no disponible",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Capacidad
            Row(
              children: [
                Icon(Icons.people, color: Colors.green),
                SizedBox(width: 5),
                Text(
                  "Capacidad: ${cancha['capacidad'] ?? "No especificada"} personas",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            // Comentarios
            Text(
              "Comentarios",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (cancha['comentarios'] != null &&
                cancha['comentarios'].isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cancha['comentarios'].length,
                itemBuilder: (context, index) {
                  final comentario = cancha['comentarios'][index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          comentario['user'][0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        comentario['texto'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating:
                                comentario['calificacion']?.toDouble() ?? 0.0,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                          Text(
                            "Fecha: ${DateTime.parse(comentario['fecha_creacion']).toLocal()}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Text(
                "Aún no hay comentarios sobre esta cancha.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 20),
            // Botones: Reservar y Ver Dirección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para reservar (puedes redirigir a otra pantalla o mostrar un mensaje temporal)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Próximamente: Reservar cancha")),
                    );
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text("Reservar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openMaps(
                      context), // Llama al método para abrir Google Maps
                  icon: Icon(Icons.map),
                  label: Text("Ver Dirección"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
