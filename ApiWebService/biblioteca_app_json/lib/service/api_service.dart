import 'dart:convert';

// precisa colocar a biblioteca do http -> pub add http 

class ApiService {
  static const String baseUrl = "http://localhost3004"; // url base api 
  // métodos de classe para acessar os endpoints da api 
  // GET (all)
  static Future<List<dynamic>> getList(String path) async {
      final res = await http.get(Uri.parse("$baseUrl/$path"));
      // no dart precisa converter String em endereço url (URI.pare)
      if(res.statusCode == 200) 
        return json.decode(res.body); // se resposta PK -> converte json em MAP<dynamic>
         // se deu ruim --. a conexão gera erro 
         // vou gerar um erro 
        throw Exception("Falha de conexão $path");
    }

    // GET (one)
  static Future<Map<String, dynamic>> getOne(String path, String id) async {
    final res = await http.get(Uri.parse("$baseUrl/$path;$id"));
    if (res.statusCode == 200) return json.decode(res.body);
    // se der ruim
    throw Exception("Falha de conexão com $path");
  }

    // POST 
  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse("$baseUrl/$path"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (res.statusCode == 201) return jsonDecode(res.body);
    // se der errado 
    throw Exception("Falha de conexão com $path");
  }
    //PUT 
      static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
    String id
  ) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$path/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    //se der errado
    throw Exception("Falha de conexão com $path");
  }


    //DELETE
    static delete(String path, String id) async {
      final res = await http.delete(Uri.parse("$baseUrl/$path/$id"));
      if(res.statusCode != 200) throw Exception("Falha ao deletar de $path");
    }

}

