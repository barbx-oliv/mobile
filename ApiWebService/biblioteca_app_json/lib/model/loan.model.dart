import 'book.model.dart';
import 'user_model.dart';

class LoanModel {
    // Atributos 
    final String? id;
    final UserModel user;
    final BookModel book;
    final DateTime startDate;
    final DateTime dueDate;
    final bool returned;

    // Construtor 
    LoanModel({
        this.id,
        required this.user,
        required this.book,
        required this.startDate,
        required this.dueDate,
        required this.returned
    });

    // Métodos ToMap e FromMap 
    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": user.toMap(),
        "bookId": book.toMap(),
        "startDate": startDate.toIso8601String(),
        "dueDate": dueDate.toIso8601String(),
        "returned": returned
    };

    factory LoanModel.fromMap(Map<String, dynamic> map) => 
    LoanModel(
        id: map["id"].toString(),
        user: UserModel.fromMap(map["userId"]),
        book: BookModel.fromMap(map["bookId"]),
        startDate: DateTime.parse(map["startDate"].toString()),
        dueDate: DateTime.parse(map["dueDate"].toString()),
        returned: map["returned"] == true ? true : false
    );
}