import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/drink.dart';

/// Serviço responsável por fazer as requisições HTTP para a API TheCocktailDB
class CocktailService {
  static const String _baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';

  /// Busca drinks por letra inicial
  /// [letter] - letra de A a Z para buscar drinks
  Future<List<Drink>> searchByLetter(String letter) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.php?f=$letter'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // A API retorna null em 'drinks' se não houver resultados
        if (data['drinks'] == null) {
          return [];
        }

        return (data['drinks'] as List)
            .map((drink) => Drink.fromJson(drink))
            .toList();
      } else {
        throw Exception('Falha ao carregar drinks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Busca drinks por nome
  /// [name] - nome ou parte do nome do drink para buscar
  Future<List<Drink>> searchByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.php?s=$name'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // A API retorna null em 'drinks' se não houver resultados
        if (data['drinks'] == null) {
          return [];
        }

        return (data['drinks'] as List)
            .map((drink) => Drink.fromJson(drink))
            .toList();
      } else {
        throw Exception('Falha ao buscar drinks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
