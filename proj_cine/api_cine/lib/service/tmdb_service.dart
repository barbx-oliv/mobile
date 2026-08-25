
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_service.dart';
import 'package:api_cine/model/movie_model.dart';

// arrumar http 

class TmdbService {
    static const String baseUrl = " https://api.themoviedb.org/3."; // url base 
    // métodos para acessar os endpoints da api 

    // pesquisa filme
    Future<List<MovieModel>> searchMovie(String query) async {
        final url = Uri.parse("$_baseUrl/search/movie?api_key=$[Config.tmdApiKey]$query=${Uri.encodeComponent(query)}&language=pt-BR");
        return  _fetchData(url);
    }

    // GET (one)
    static Future<Map<String, dynamic>> getOne(String path, String id) async {
        final res = await http.get(Uri.parse("$baseUrl/$path;$id"));
        if (res.statusCode == 200) return json.decode(res.body);
        throw Exception("Falha de conexão com $path");
    }


    // POST (adicionar aos favoritos)


    //DELETE   
    static delete(String path, String id) async {
        final res = await http.delete(Uri.parse("$baseUrl/$path/$id"));
        if(res.statusCode != 200) throw Exception("Falha ao deletar de $path");
    }
}