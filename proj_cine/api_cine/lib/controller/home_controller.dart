import 'package:api_cine/model/movie_model.dart';
import 'package:api_cine/service/tmdb_service.dart';

class HomeController {
  final TmdbService _tmdbService = TmdbService();

  // Executa a busca através do service
  Future<List<Movie>> searchMovies(String query) async {
    return await _tmdbService.fetchMovies(query);
  }
}