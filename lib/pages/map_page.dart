import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ApiService _apiService = ApiService();
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCanchas();
  }

  void _loadCanchas() async {
    try {
      final canchas = await _apiService.fetchCanchas();
      setState(() {
        _markers = canchas
            .where((cancha) =>
                cancha['latitud'] != null &&
                cancha['longitud'] != null) // Filtra valores nulos
            .map<Marker>((cancha) {
          return Marker(
            markerId: MarkerId(cancha['id'].toString()),
            position: LatLng(
              cancha['latitud'] ??
                  0.0, // Asigna valor predeterminado si es null
              cancha['longitud'] ??
                  0.0, // Asigna valor predeterminado si es null
            ),
            infoWindow: InfoWindow(
              title: cancha['nombre'] ?? "Sin nombre",
              snippet: cancha['direccion'] ?? "Sin dirección",
            ),
          );
        }).toSet();
        _isLoading = false; // Deja de cargar una vez completado
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Detiene el indicador de carga
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
        title: Text("Mapa de Canchas"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    40.7684, -73.5251), // Coordenadas iniciales relevantes
                zoom: 12,
              ),
              markers: _markers,
            ),
    );
  }
}
