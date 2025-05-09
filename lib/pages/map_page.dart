import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kicknplay_app/pages/reservar_cancha_page.dart';
import '../services/api_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ApiService _apiService = ApiService();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {}; // Polilíneas para las rutas
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(40.7684, -73.5251);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogoMarker();
    _getCurrentLocation();
    _loadCanchas();
  }

  Future<void> _loadLogoMarker() async {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/k&plogo.jpg',
    ).then((value) {
      setState(() {});
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("El servicio de ubicación está deshabilitado.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permiso de ubicación denegado.")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Permiso de ubicación denegado permanentemente.")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: MarkerId("ubicacion_actual"),
            position: _currentLocation,
            infoWindow: InfoWindow(
              title: "Mi Ubicación",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );

        _isLoading = false;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_currentLocation),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener la ubicación: $e")),
      );
    }
  }

  void _loadCanchas() async {
    try {
      final canchas = await _apiService.fetchCanchas();

      setState(() {
        _markers.addAll(
          canchas.map<Marker>((cancha) {
            final LatLng position = LatLng(
              cancha['latitud'] ?? 0.0,
              cancha['longitud'] ?? 0.0,
            );
            final String nombre = cancha['nombre'] ?? "Cancha sin nombre";
            final String direccion =
                cancha['direccion'] ?? "Dirección no disponible";
            final String? imageUrl = cancha['imagen'];

            return Marker(
              markerId: MarkerId(cancha['id'].toString()),
              position: position,
              infoWindow: InfoWindow(
                title: nombre,
                snippet: "Haz clic aquí para reservar",
                onTap: () async {
                  try {
                    final FlutterSecureStorage secureStorage =
                        FlutterSecureStorage();

                    // Obtener el username desde FlutterSecureStorage
                    final String? username =
                        await secureStorage.read(key: 'username');
                    if (username == null) {
                      throw Exception(
                          "No se encontró el username. Por favor inicia sesión primero.");
                    }

                    // Obtener el token desde FlutterSecureStorage
                    final String? token =
                        await secureStorage.read(key: 'access_token');
                    if (token == null) {
                      throw Exception(
                          "No se encontró el token. Por favor inicia sesión primero.");
                    }

                    // Llamar al API para obtener el usuario por username
                    final response = await http.post(
                      Uri.parse(
                          'https://kickandplay-3b16b2f1fd11.herokuapp.com/api/obtener_usuario/'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: json.encode({'username': username}),
                    );

                    if (response.statusCode != 200) {
                      throw Exception(
                          "Error al obtener la información del usuario: ${response.body}");
                    }

                    final data = json.decode(response.body);
                    final int usuarioId =
                        data['id']; // Extrae el ID del usuario

                    // Llamar al modal con el ID dinámico del usuario
                    _showCanchaDetailsWithButtons(
                      position, // Coordenadas de la cancha
                      nombre, // Nombre de la cancha
                      direccion, // Dirección de la cancha
                      imageUrl, // URL de la imagen
                      usuarioId, // ID dinámico del usuario obtenido
                      cancha, // Objeto completo de la cancha
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                },
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            );
          }).toSet(),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las canchas: $e")),
      );
    }
  }

  void _showCanchaDetailsWithButtons(
      LatLng position,
      String nombre,
      String direccion,
      String? imageUrl,
      int usuarioId,
      Map<String, dynamic> cancha) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la cancha
              Center(
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Imagen predeterminada si hay error al cargar
                          return Image.asset(
                            'assets/k&plogo.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/k&plogo.jpg', // Imagen predeterminada
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 10),

              // Nombre de la cancha
              Text(
                nombre,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),

              // Dirección de la cancha
              Text(
                direccion,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),

              // Botones interactivos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cierra el modal
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservarCanchaPage(
                            cancha: cancha, // Pasa la información de la cancha
                            usuarioId: usuarioId, // Pasa el ID del usuario
                          ),
                        ),
                      ); // Navega a la página de reservas
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0077FF),
                    ),
                    child: Text("Hacer Reserva"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cierra el modal
                      _showRouteToCancha(position); // Calcula y muestra rutas
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text("Mostrar Rutas"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRouteToCancha(LatLng canchaPosition) async {
    try {
      // URL base de la API Directions
      final String baseUrl =
          "https://maps.googleapis.com/maps/api/directions/json";
      final String apiKey =
          "AIzaSyBhIssxZqO6LEianMabpvH0Fur5yVxpBxI"; // Reemplaza con tu clave API

      // Coordenadas de origen y destino
      final String origin =
          "${_currentLocation.latitude},${_currentLocation.longitude}";
      final String destination =
          "${canchaPosition.latitude},${canchaPosition.longitude}";

      // URL completa para la solicitud
      final String url =
          "$baseUrl?origin=$origin&destination=$destination&key=$apiKey";

      // Depuración: verifica que la URL es correcta
      print("URL de solicitud: $url");

      // Realiza la solicitud HTTP con manejo de timeout
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

      // Verifica si la solicitud fue exitosa
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verifica si hay rutas disponibles
        if ((data['routes'] as List).isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polylineCoordinates = _decodePolyline(points);

          setState(() {
            _polylines.clear(); // Limpia las rutas anteriores
            _polylines.add(
              Polyline(
                polylineId: PolylineId("ruta_cancha"),
                points: polylineCoordinates, // Coordenadas decodificadas
                color: Colors.blue, // Color de la ruta
                width: 5, // Ancho de la línea
              ),
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ruta trazada exitosamente!")),
          );
        } else {
          // No se encontraron rutas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No se encontraron rutas.")),
          );
        }
      } else {
        // Error en la respuesta
        print("Error en la respuesta de la API: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al obtener rutas: ${response.body}")),
        );
      }
    } catch (e) {
      // Excepción capturada
      print("Error al calcular la ruta: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al calcular rutas: $e")),
      );
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa de Canchas"),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 12.0,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
    );
  }
}
