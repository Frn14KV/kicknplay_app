import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = "https://kickandplay-3b16b2f1fd11.herokuapp.com/api/";
  final secureStorage = FlutterSecureStorage();

  Future<List<dynamic>> fetchCanchas() async {
    // Recupera el token desde almacenamiento seguro
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'access_token');
    if (token == null) {
      throw Exception(
          "No se encontró el token. Por favor, inicia sesión primero.");
    }

    final response = await http.get(
      Uri.parse('${baseUrl}canchas/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al cargar las canchas: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchReservas() async {
    // Recupera el token desde almacenamiento seguro
    final token = await secureStorage.read(key: 'access_token');
    if (token == null) {
      throw Exception(
          "No se encontró el token. Por favor inicia sesión primero.");
    }

    // Solicitud GET al endpoint de reservas con el token
    final response = await http.get(
      Uri.parse('${baseUrl}reservas/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve la lista de reservas
    } else {
      throw Exception("Error al cargar las reservas: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchEventos() async {
    // Recupera el token desde almacenamiento seguro
    final token = await secureStorage.read(key: 'access_token');
    if (token == null) {
      throw Exception(
          "No se encontró el token. Por favor inicia sesión primero.");
    }

    // Solicitud GET al endpoint de eventos con el token
    final response = await http.get(
      Uri.parse('${baseUrl}eventos/'), // Reemplaza con el endpoint correcto
      headers: {
        'Authorization': 'Bearer $token', // Token para autenticación
        'Content-Type': 'application/json', // Especificar JSON en headers
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Devuelve la lista de eventos
    } else {
      throw Exception("Error al cargar los eventos: ${response.body}");
    }
  }
}
