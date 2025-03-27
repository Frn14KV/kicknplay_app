import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final ApiService _apiService = ApiService(); // Servicio para consumir la API
  List<dynamic> _eventos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventos(); // Cargar los eventos al inicializar
  }

  void _loadEventos() async {
    try {
      final eventos =
          await _apiService.fetchEventos(); // Método que obtiene los eventos
      setState(() {
        _eventos = eventos;
        _isLoading = false; // Detén el indicador de carga
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los eventos: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"), // Título de la página
        backgroundColor: Color(0xFF0077FF), // Azul principal
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : _eventos.isEmpty
              ? Center(child: Text("No hay eventos disponibles."))
              : ListView.builder(
                  itemCount: _eventos.length,
                  itemBuilder: (context, index) {
                    final evento = _eventos[index];
                    final reserva = evento['reserva'];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          evento['titulo'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0077FF),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evento['descripcion'],
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Tipo: ${evento['tipo_evento']}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Creado el: ${DateTime.parse(evento['fecha_creacion']).toLocal().toString().split(' ')[0]}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            if (reserva != null) ...[
                              SizedBox(height: 8),
                              Text(
                                "Reserva:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8C00),
                                ),
                              ),
                              Text(
                                "Fecha: ${reserva['fecha_reserva']}",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Hora: ${reserva['hora_inicio']} - ${reserva['hora_fin']}",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Estado: ${reserva['estado']}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                        trailing: Icon(
                          Icons.event,
                          color: Color(0xFF0077FF),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
