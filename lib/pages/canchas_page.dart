import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'cancha_details_page.dart'; // Importa la pantalla de detalles

class CanchasPage extends StatefulWidget {
  @override
  _CanchasPageState createState() => _CanchasPageState();
}

class _CanchasPageState extends State<CanchasPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _canchas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCanchas(); // Cargar las canchas al inicializar
  }

  void _loadCanchas() async {
    try {
      final canchas = await _apiService.fetchCanchas();
      setState(() {
        _canchas = canchas;
        _isLoading = false; // Detiene el indicador de carga
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las canchas: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canchas Disponibles"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : _canchas.isEmpty
              ? Center(child: Text("No hay canchas disponibles."))
              : ListView.builder(
                  itemCount: _canchas.length,
                  itemBuilder: (context, index) {
                    final cancha = _canchas[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: cancha['imagen_url'] != null
                            ? Image.network(
                                cancha['imagen_url'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/k&plogo.jpg', // Logo de tu app
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                        title: Text(
                          cancha['nombre'] ?? "Sin nombre",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Ubicación: ${cancha['direccion'] ?? "No disponible"}\n"
                          "Capacidad: ${cancha['capacidad'] ?? "N/A"}",
                        ),
                        onTap: () {
                          // Navega a la pantalla de detalles de la cancha
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CanchaDetailsPage(
                                cancha: cancha,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
