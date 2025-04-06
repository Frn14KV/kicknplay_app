import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

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

  void participarEnEvento(int eventoId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Te has inscrito en el evento ID: $eventoId")),
    );
  }

  void editarEvento(dynamic evento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEventoPage(evento: evento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
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
                    final esPublico =
                        evento['tipo_evento'] == 'publico'; // Verificar tipo

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          evento['titulo'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0077FF),
                            fontSize: 18,
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
                                fontSize: 14,
                                color: esPublico ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Creado el: ${DateTime.parse(evento['fecha_creacion']).toLocal().toString().split(' ')[0]}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: esPublico
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.group_add,
                                        color: Color(0xFF0077FF)),
                                    onPressed: () =>
                                        participarEnEvento(evento['id']),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => editarEvento(evento),
                                  ),
                                ],
                              )
                            : Icon(Icons.lock,
                                color: Colors.grey), // Indicador de privado
                      ),
                    );
                  },
                ),
    );
  }
}

// Pantalla de edición de evento (Placeholder)
class EditarEventoPage extends StatelessWidget {
  final dynamic evento;

  const EditarEventoPage({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Evento"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Editar detalles del evento:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Título: ${evento['titulo']}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Descripción: ${evento['descripcion']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Tipo de evento: ${evento['tipo_evento']}",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
