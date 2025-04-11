import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://kickandplay-3b16b2f1fd11.herokuapp.com/api/";
  final secureStorage = const FlutterSecureStorage();

  // Registro: Crea un nuevo usuario y almacena el token y username
  Future<void> register(
      String username, String email, String password1, String password2) async {
    final response = await http.post(
      Uri.parse('${baseUrl}registro/'),
      body: json.encode({
        'username': username,
        'email': email,
        'password1': password1,
        'password2': password2,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);

      // Guardar el access token, refresh token y username
      await secureStorage.write(
          key: 'access_token', value: data['access_token']);
      await secureStorage.write(
          key: 'refresh_token', value: data['refresh_token']);
      await secureStorage.write(key: 'username', value: username);
    } else {
      throw Exception('Error al registrarse: ${response.body}');
    }
  }

  // Inicio de sesión: Obtiene el access token y el refresh token
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}token/'),
      body: json.encode({
        'username': username,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Guardar el access token y el refresh token de manera segura
      await secureStorage.write(key: 'access_token', value: data['access']);
      await secureStorage.write(key: 'refresh_token', value: data['refresh']);
      await secureStorage.write(key: 'username', value: username);
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Obtener un nuevo access token usando el refresh token
  Future<void> refreshAccessToken() async {
    final refreshToken = await secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      throw Exception(
          'No se encontró el refresh token. Inicia sesión nuevamente.');
    }

    final response = await http.post(
      Uri.parse('${baseUrl}token/refresh/'),
      body: json.encode({
        'refresh': refreshToken,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Actualizar el access token en el almacenamiento seguro
      await secureStorage.write(key: 'access_token', value: data['access']);
    } else {
      throw Exception('Error al renovar el token: ${response.body}');
    }
  }

  // Eliminar tokens al cerrar sesión
  Future<void> logout() async {
    await secureStorage.delete(key: 'access_token');
    await secureStorage.delete(key: 'refresh_token');
    await secureStorage.delete(key: 'username'); // Borrar el username
  }

  // Leer el token almacenado
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<String?> getUsername() async {
    return await secureStorage.read(key: 'username');
  }
}
