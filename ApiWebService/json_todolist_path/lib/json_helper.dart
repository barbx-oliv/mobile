import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// método 1 
class JsonHelper {
  // método para obter o arquivo json do path 
  // static -> metodo da classe e não do objeto, eu só declaro a classe e chamo o método
  static Future<File> _getArquivo() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/config.json");
  }

  // 2 Método -> salvar os dados no arquivo json 
  static Future<Map<String, dynamic>> lerDados() async{
    try{
        // pega o arquivo json 
        final arquivo = await _getArquivo();
        //verifica se ele existe 
        if(await arquivo.exists()){
          // leio o conteúdo do arquivo
          final conteudo = await arquivo.readAsString();
          //converto o conteúdo do arquivo em Map 
          return json.decode(conteudo);
        }
    } catch (e) {
      print("Erro ao ler dados: $e");
    }
    return {};
  }

  // Metodo para salvar os dados no json 
  static Future<void> salvarDados(Map<String, dynamic> dados) async {
    try{
      // pega o arquivo json 
      final arquivo = await _getArquivo();
      //converte o map em string 
      final conteudo = json.encode(dados);
      //salva o conteudo no arquivo 
      await arquivo.writeAsString(conteudo);
    } catch (e) {
      print("Erro ao salvar dados: $e");
    }
  }
}