// lib/services/api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base da API
  final String baseUrl = 'http://192.168.0.47:6600/api/auth';

  // Função para realizar login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final String apiUrl = '$baseUrl/login';
    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Retorna os dados de resposta
      } else {
        return {'error': 'Erro: ${response.body}'}; // Retorna erro
      }
    } catch (e) {
      return {'error': 'Erro: $e'}; // Retorna erro de conexão
    }
  }

  // Função para realizar cadastro
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final String apiUrl = '$baseUrl/registre';
    final body = {
      "username": username,
      "email": email,
      "password": password
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body); // Retorna os dados de resposta
      } else {
        return {'error': 'Erro: ${response.body}'}; // Retorna erro
      }
    } catch (e) {
      return {'error': 'Erro: $e'}; // Retorna erro de conexão
    }
  }
}
