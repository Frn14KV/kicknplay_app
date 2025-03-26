import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReservasPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Reservas"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : _reservas.isEmpty
              ? Center(child: Text("No tienes reservas."))
              : ListView.builder(
                  itemCount: _reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = _reservas[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          "Cancha ID: ${reserva['cancha']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Fecha: ${reserva['fecha_reserva']}\n"
                          "Inicio: ${reserva['hora_inicio']} - Fin: ${reserva['hora_fin']}\n"
                          "Estado: ${reserva['estado']}",
                        ),
                        trailing: Icon(
                          reserva['estado'] == "pendiente"
                              ? Icons.hourglass_empty
                              : Icons.check_circle,
                          color: reserva['estado'] == "pendiente"
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
