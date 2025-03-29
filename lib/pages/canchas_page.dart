import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Para obtener la ubicación del usuario
import '../services/api_service.dart';
import 'cancha_details_page.dart'; // Importa la pantalla de detalles
import 'dart:math'; // Importa funciones matemáticas como sin, cos, atan2, sqrt

class CanchasPage extends StatefulWidget {
  @override
  _CanchasPageState createState() => _CanchasPageState();
}

class _CanchasPageState extends State<CanchasPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController =
      TextEditingController(); // Controlador del campo de búsqueda
  List<dynamic> _canchas = []; // Lista completa de canchas
  List<dynamic> _filteredCanchas = []; // Lista filtrada de canchas
  bool _isLoading = true;
  bool _isNearbyChecked = false; // Estado del checkbox "Cerca de mí"
  Position? _currentPosition; // Posición actual del usuario

  @override
  void initState() {
    super.initState();
    _loadCanchas();
    _getUserLocation(); // Obtiene la ubicación del usuario
  }

  // Obtener la ubicación actual del usuario
  void _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor activa el servicio de ubicación")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permiso de ubicación denegado")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Permiso de ubicación denegado permanentemente")),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position; // Almacena la ubicación actual del usuario
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener la ubicación: $e")),
      );
    }
  }

  // Cargar las canchas desde el API
  void _loadCanchas() async {
    try {
      final canchas = await _apiService.fetchCanchas();
      setState(() {
        _canchas = canchas;
        _filteredCanchas = canchas; // Inicialmente muestra todas las canchas
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

  // Calcular la distancia entre dos puntos (Fórmula de Haversine)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radio de la Tierra en km
    final dLat = (lat2 - lat1) * (pi / 180); // Usa `pi` de dart:math
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Devuelve la distancia en kilómetros
  }

  // Filtrar canchas
  void _buscarCanchas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCanchas = _canchas.where((cancha) {
        final nombreCoincide = cancha['nombre']
            .toString()
            .toLowerCase()
            .contains(query); // Filtro por nombre

        final esCercana = _isNearbyChecked
            ? (_currentPosition != null &&
                _calculateDistance(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                      cancha['latitud'] ?? 0.0,
                      cancha['longitud'] ?? 0.0,
                    ) <=
                    10) // Rango de 10 km
            : true; // Si no está activado, ignora cercanía

        return nombreCoincide && esCercana;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canchas Disponibles"),
        backgroundColor: Color(0xFF0077FF), // Azul consistente
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Campo de Búsqueda
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Buscar por nombre",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) =>
                        _buscarCanchas(), // Filtra mientras escribe
                  ),
                  SizedBox(height: 10),

                  // Checkbox "Cerca de mí"
                  Row(
                    children: [
                      Checkbox(
                        value: _isNearbyChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isNearbyChecked = value ?? false;
                            _buscarCanchas(); // Actualiza la búsqueda con el filtro
                          });
                        },
                      ),
                      Text("Cerca de mí"),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Lista de Canchas
                  Expanded(
                    child: _filteredCanchas.isEmpty
                        ? Center(child: Text("No se encontraron canchas"))
                        : ListView.builder(
                            itemCount: _filteredCanchas.length,
                            itemBuilder: (context, index) {
                              final cancha = _filteredCanchas[index];
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                  ),
                ],
              ),
            ),
    );
  }
}
