import '../model/book.model.dart';
import '../service/api_service.dart';

class BookController {
  // Métodos 

  // Ler 
  Future<List<BookModel>> fetchAll() async {
    final list = await ApiService.getList("books?_sort=name");
    return list.map<BookModel>((item) => BookModel.fromMap(item)).toList();
  }

  //Ler um unico Livro
  Future<BookModel> fetchOne(String id) async {
    final book = await ApiService.getOne("book", id);
    return BookModel.fromMap(book);
  }

  // Criar 
  Future<BookModel> create(BookModel u) async {
    final created = await ApiService.post("books", u.toMap());
    return BookModel.fromMap(created);
  }

  // Atualizar 
  Future<BookModel> update(BookModel u) async {
    final update = await ApiService.put("books", u.toMap(), u.id!);
    return BookModel.fromMap(update);
  }

  // Deletar 
  Future<void> delete(String id) async {
    await ApiService.delete("books", id);
  }
}