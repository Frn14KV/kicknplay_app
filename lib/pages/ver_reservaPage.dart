import 'package:flutter/material.dart';

class VerReservaPage extends StatelessWidget {
  final dynamic reserva;

  const VerReservaPage({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver Reserva"),
        backgroundColor: Color(0xFF0077FF),
        elevation: 0, // Estilo plano
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: reserva['estado'] == "pendiente"
                        ? Colors.orange
                        : Colors.green,
                    child: Icon(
                      Icons.calendar_today,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Cancha: ${reserva['cancha']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF0077FF),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Fecha: ${reserva['fecha_reserva']}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Hora: ${reserva['hora_inicio']} - ${reserva['hora_fin']}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Estado: ${reserva['estado']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: reserva['estado'] == "pendiente"
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0077FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Volver",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
