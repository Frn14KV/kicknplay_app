import 'package:flutter/material.dart';
import 'package:kicknplay_app/pages/editar_reserva_page.dart';
import 'package:kicknplay_app/pages/ver_reservaPage.dart';
import '../services/api_service.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  _ReservasPageState createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _reservas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservas(); // Cargar las reservas al inicializar
  }

  void _loadReservas() async {
    try {
      final reservas = await _apiService.fetchReservas();
      setState(() {
        _reservas = reservas;
        _isLoading = false; // Detén el indicador de carga
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las reservas: $e")),
      );
    }
  }

  bool esFutura(String fechaReserva) {
    final DateTime reservaDate = DateTime.parse(fechaReserva);
    final DateTime currentDate = DateTime.now();
    return reservaDate.isAfter(currentDate);
  }

  void verReserva(dynamic reserva) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerReservaPage(reserva: reserva),
      ),
    );
  }

  void editarReserva(dynamic reserva) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarReservaPage(reserva: reserva),
      ),
    );
  }

  void eliminarReserva(int reservaId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar Reserva"),
        content: Text("¿Estás seguro de que deseas eliminar esta reserva?"),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Reserva ID: $reservaId eliminada exitosamente."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Reservas"),
        backgroundColor: Color(0xFF0077FF),
        elevation: 0, // Estilo plano
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : _reservas.isEmpty
              ? Center(
                  child: Text(
                    "No tienes reservas.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = _reservas[index];
                    final bool isFutureReservation =
                        esFutura(reserva['fecha_reserva']);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: isFutureReservation
                              ? Colors.orange
                              : Colors.green,
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Cancha: ${reserva['cancha']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0077FF),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fecha: ${reserva['fecha_reserva']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Hora: ${reserva['hora_inicio']} - ${reserva['hora_fin']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Estado: ${reserva['estado']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: reserva['estado'] == "pendiente"
                                      ? Colors.orange
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: isFutureReservation
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Color(0xFF0077FF),
                                    ),
                                    onPressed: () => verReserva(reserva),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () => editarReserva(reserva),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        eliminarReserva(reserva['id']),
                                  ),
                                ],
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Color(0xFF0077FF),
                                ),
                                onPressed: () => verReserva(reserva),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
