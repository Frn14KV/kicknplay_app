import 'package:flutter/material.dart';
import '/services/api_service.dart'; // Importa ApiService

class ReservarCanchaPage extends StatefulWidget {
  final Map<String, dynamic> cancha;
  final int usuarioId; // ID del usuario que realiza la reserva

  const ReservarCanchaPage(
      {super.key, required this.cancha, required this.usuarioId});

  @override
  _ReservarCanchaPageState createState() => _ReservarCanchaPageState();
}

class _ReservarCanchaPageState extends State<ReservarCanchaPage> {
  final ApiService _apiService = ApiService(); // Instancia de ApiService
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaInicioSeleccionada;
  TimeOfDay? _horaFinSeleccionada;

  // Función para mostrar el selector de fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  // Función para mostrar el selector de hora inicio
  Future<void> _seleccionarHoraInicio(BuildContext context) async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaInicioSeleccionada = hora;
      });
    }
  }

  // Función para mostrar el selector de hora fin
  Future<void> _seleccionarHoraFin(BuildContext context) async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: _horaInicioSeleccionada ?? TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaFinSeleccionada = hora;
      });
    }
  }

  // Validar y enviar la reserva
  Future<void> _confirmarReserva() async {
    if (_fechaSeleccionada == null ||
        _horaInicioSeleccionada == null ||
        _horaFinSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    // Convertir datos al formato necesario
    final fechaReserva = _fechaSeleccionada!.toLocal().toString().split(' ')[0];
    final horaInicio =
        "${_horaInicioSeleccionada!.hour.toString().padLeft(2, '0')}:${_horaInicioSeleccionada!.minute.toString().padLeft(2, '0')}:00";
    final horaFin =
        "${_horaFinSeleccionada!.hour.toString().padLeft(2, '0')}:${_horaFinSeleccionada!.minute.toString().padLeft(2, '0')}:00";

    // Crear objeto de reserva
    final reserva = {
      "usuario": widget.usuarioId, // ID del usuario
      "cancha": widget.cancha['id'], // ID de la cancha
      "fecha_reserva": fechaReserva, // Fecha en formato "AAAA-MM-DD"
      "hora_inicio": horaInicio, // Hora inicio en formato "HH:MM:SS"
      "hora_fin": horaFin, // Hora fin en formato "HH:MM:SS"
      "estado": "pendiente" // Estado inicial de la reserva
    };

    try {
      await _apiService.createReserva(reserva); // Llama al método de ApiService
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reserva realizada con éxito")),
      );
      Navigator.pop(context); // Regresa a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al realizar la reserva: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservar ${widget.cancha['nombre']}"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selecciona la fecha y horas para tu reserva",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Selector de fecha
            TextButton(
              onPressed: () => _seleccionarFecha(context),
              child: Text(
                _fechaSeleccionada != null
                    ? "Fecha seleccionada: ${_fechaSeleccionada?.toLocal().toString().split(' ')[0]}"
                    : "Seleccionar fecha",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),

            // Selector de hora inicio
            TextButton(
              onPressed: () => _seleccionarHoraInicio(context),
              child: Text(
                _horaInicioSeleccionada != null
                    ? "Hora inicio: ${_horaInicioSeleccionada?.format(context)}"
                    : "Seleccionar hora inicio",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),

            // Selector de hora fin
            TextButton(
              onPressed: () => _seleccionarHoraFin(context),
              child: Text(
                _horaFinSeleccionada != null
                    ? "Hora fin: ${_horaFinSeleccionada?.format(context)}"
                    : "Seleccionar hora fin",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),

            // Botón para confirmar reserva
            Center(
              child: ElevatedButton(
                onPressed: _confirmarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: Text("Confirmar Reserva"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
