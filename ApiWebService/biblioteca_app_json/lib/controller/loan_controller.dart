import '../model/loan.model.dart';
import '../service/api_service.dart';

class LoanController {
  // Métodos 

  // ler 
  Future<List<LoanModel>> fetchAll() async {
    final list = await ApiService.getList("loans?_sort=loadDate");
    return list.map<LoanModel>((item) => LoanModel.fromMap(item)).toList();
  }

  // Criar um empréstimo 
  Future<LoanModel> create(LoanModel loan) async {
    final created = await ApiService.post("loans", loan.toMap());
    return LoanModel.fromMap(created);
  }

  // Atualizar um empréstimo 
  Future<LoanModel> update(LoanModel loan) async {
    final update = await ApiService.put("loans", loan.toMap(), loan.id!);
    return LoanModel.fromMap(update);
  }
}