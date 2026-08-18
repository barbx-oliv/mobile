import 'package:flutter/material.dart';
import 'package:biblioteca_app_json/controller/book_controller.dart';
import 'package:biblioteca_app_json/model/book_model.dart';


class BookFormPage extends StatefulWidget {
    // Atributos 
    const BookFormPage({super.key, this.user});

    @override
    State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
    // Atributos 
    final _formkey = GlobalKey<FormState>(); //Armazena as informações do formulário  
    final _titleController = TextEditingController(); // Campo para digitar o titulo do livro 
    final _authorController = TextEditingController(); // Campo para digitar o autor do livro
    bool _avaliableInput = true; 
    String idBook = "";
    String _error = "";
    final BookController _controller = BookController();

    @override
    void initState() {
        super.initState();
        if (widget.book != null) {
            _titleController.text = widget.book!.title;
            _authorController.text = widget.book!.author;
            _avaliable = widget;book!.avaliable;
        }
    }

    Future <void> _save() async {
        if (_formkey.currentState!.validate()) 
            final book = BookModel(
                title: _titleController.text.trim(),
                author: _authorController.text.trim(),
                avaliable: _avaliable,
            );
        if (widget.book == null) {
            await _controller.create(book);
        } else {
            await _controlle.update(book);
        }
        if (mouted) Navigator.pop(context, true);
    }


    @override 
    Widget build(BuildContext context) {
        return Scaffold(
            appbar: AppBar(title: Text(widget.book == null ? "Novo livro" : "Editar livro ${widget.book!.title}"),),
            body: Padding(padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                    children [
                        TextFormField(
                            controller: _titleInput,
                            decoration: InputDecoration(labelText: "Titulo"),
                            validator: (v) => v == null || v.trim().isEmpty ? "Campo orbigatório" : null,
                        ),
                        TextFormField(
                            controller: _avaliableInput,
                            decoration: InputDecoration(labelText: "Avaliação"),
                            validator: (value) => value!.isEmpty ? "Informe a avaliação" : null,
                        ),
                        const SizedBox(height: 16),
                        SwitchLisTile(
                            title: const Text("Disponível"),
                            value: _avaliable,
                            onChaged: (v) => setState(() => _avaliable = v)
                        )
                        SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: _save,
                            child: Text(isEditing ? "Atualizar" : "Criar"),
                        ),
                    ],
                )
            ),),
        );
    }
}