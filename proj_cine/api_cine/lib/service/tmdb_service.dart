import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_cine/model/movie_model.dart';
import 'config_service.dart';

class TmdbService {
  Future<List<Movie>> fetchMovies(String query) async {
    if (query.isEmpty) return [];

    // Usa a URL base e a chave do ConfigService
    final url = Uri.parse('${ConfigService.baseUrl}/search/movie?api_key=${ConfigService.tmdbApiKey}&query=$query&language=pt-BR');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        
        return results.map((jsonMovie) => Movie.fromJson(jsonMovie)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erro na requisição TMDB: $e');
      return [];
    }
  }
}