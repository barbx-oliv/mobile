import 'package:biblioteca_app_json/controller/user_controller.dart';
import 'package:biblioteca_app_json/model/user_model.dart';
import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {

// Atributos 
  const UserModel? user; // Pode ser nulo 
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
    // Atributos 
    final _formkey = GlobalKey<FormState>(); // Armazena as informações do formulário 
    final _userController = UserController();
    final _nameInput = TextEditingController();
    final _emailInput = TextEditingController();
    String idUser = "";
    String _error = "";


    // Se exisir dados do usuário precisa do init state
    @override
    void initState() {
        super.initState();
        // pega os dados se for edição 
        if(widget.user != null){
            idUser = widget.user!.id!;
            _nameInput.text = widget.user!.name;
            _emailInput.text - widget.user!.email;
        }
    } 

    void save() async {
        if(_formkey.currentState!.validate()) {
            final user = UserModel(
                name: _nameInput.text.trim(),
                email: _emailInput.text.trim());
            try {
                await _userController.create(user);
            } catch (e) {
                // tratar erro 
                _error = e.toString();
            }
            await _userController.create(user);
            Navigator.pop(context);
            // Se nn der certo, fazer um navigator pushname 
        }
    }

    void update() async {
        if(_formkey.currentState!.validate()){
            final user = UserModel (
                id: widget.user!.id!,
                name: _nameInput.text.trim(),
                email: _emailInput.text.trim();
            try {
                await _userController.update(user);
            } catch (e) {
                // tratar erro 
            }
            Navigator.pop(context);
            )
        }
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appbar: AppBar(title: Text(widget.user == null ? "Novo usuário" : "Editar Usuário ${widget.user!.name}"),),
            body: Pading(padding: EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                    children: [
                        TextFormField(
                            controller: _nameInput,
                            decoration: InputDecoration(labelText: "Nome"),
                            validator: (value) => value!.isEmpty ? "Informe o nome" : null,
                        ),
                        
                        TextFormField(
                            controller: _nameInput,
                            decoration: InputDecoration(labelText: "Email"),
                            validator: (value) => value!.isEmpty ? "Informe o email" : null,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: widget.user == null ? save : update,
                            child: Text(widget.user == null ? "Salvar" : "Atualizar"))
                    ],
                )),),
        );
    }
}