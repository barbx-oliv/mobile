import 'package:flutter/material.dart';
import 'package:biblioteca_app_json/model/loan_model.dart';


class LoanFormPage extends StatefulWidget {
    final LoanModel? loan;
  const LoanFormPage({super.key, this.loan});

  @override
  State<LoanFormPage> createState() => _LoanFormPageState();
}

class _LoanFormPageState extends State<LoanFormPage> {
    // Atributos 
    final _formkey = GlobalKey<FormState>();
    final LoanController _loanController = LoanController();
    final UserController _userController = UserController();
    final BookController _bookController = BookController();

    UserModel? _selectedUser;
    BookModel? _selectedBook;
    DateTime _startDate = DateTime.now();
    DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
    bool _returned = false;

    void initState() {
        super.initState();
        _loanData();
        if (widget.loan != null) {
            _selectedUser = widget.loan!.user;
            _selectedBook = widget.loan!.book;
            _startDate = widget.loan!.startDate;
            _dueDate = widget.loan!.dueDate;
            _returned = widget.loan!.returned;
        }
    }

    _loanData() async {
        final users = await _userController.fetchAll();
        final books = await _bookController.fetchAll();
        setState(() {
            _users = users;
            _books = books;
            _loading = false;
        });
    }

    _save() async {
        if (_selectedUser == null || _selectedBook == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const showSnackBar(content: Text("Selecione um usuário e um livro")),
            );
            return;
        }
        final loan = LoanModel(
            id: widget.loan?.id,
            user: _selectedUser!,
            book: _selectedBook!,
            startDate: _startDate,
            dueDate: _dueDate,
            returned: _returned,
        );
        if (widget.loan == null) {
            await _loanController.create(loan);
        } else {
            await _loanController.update(loan);
        }
        if (mouted) Navigator.pop(context, true);
    } 

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.loan != null;
    return Scaffold(
        appBar: AppBar(
            title: Text(isEditing ? "Editar Empréstimo" : "Novo Empréstimo"),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formkey,
                    child: ListView(
                        children: [
                            DropdownButtonFormField<UserModel>(
                                decoration: const InputDecoration(labelText: "Usuário"),
                                value: _selectedUser,
                                items: _users.map((u) {
                                    return DropdownMenuItem(value: u, child: Text(u.name));
                                }).toList(),
                                onChaged: (v) => setState(() => _selectedUser = v),
                                validator: (v) => 
                                    v == null ? "Selecione um usuário" : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<BookModel>(
                                decoration: const InputDecoration(labelText: "Livro"),
                                value: _selectedBook,
                                items: _books.map((b) {
                                    return DropdownMenuItem(
                                        value: b,
                                        child: Text('${b.title} - ${b.author}'),
                                    );
                                }).toList(),
                                onChaged: (v) => setState(() => _selectedBook = v),
                                validator: (v) => v == null ? "Selecione um livro" : null,
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                                title: const Text("Data de início"),
                                subtitle: Text(
                                    _startDate.toLocal().toString().split(' ')[0],
                                ),
                                trailing: const Icon(Icons.calender_today),
                                onTap: () async {
                                    final date = await showDatePicker(
                                        context: context,
                                        initialDate: _startDate,
                                        fistDate: DateTime(2020),
                                        lastDate: DateTime(2030),
                                    );
                                    if (date != null) {
                                        setState(() => _startDate = date);
                                    }
                                },
                            ),
                            ListTile(
                                title: const Text("Data de devolução"),
                                subtitle: Text(
                                    _dueDate.toLocal().toString().split(' ')[0],
                                ),
                                trailing: const Icon(Icons.calender_today),
                                onTap: (async) {
                                    final date = await showDatePicker(
                                        conte
                                        // 
                                    )
                                }
                            )
                        ]
                    )
                )
            )
    )
  }
}