import 'package:flutter/material.dart';
import 'package:biblioteca_app_json'

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    // Atributos 
    List<UserModel> _users = [];
    
    // permitir o filtro de usuários 
    final _userSearch = TextEditingController(); // Campo para digitar o nome do usuário 
    List<UserModel> _filterUsers = [];
    String _error = ""; 
    bool _isLoading = true;

    final userController = userController(); 

    // Métodos 

    @override
    void initState() { // sempre que preciso carregar as informações antes do build da page, utilizar o método init state
      super.initState();
      _load(); // para carregar as informações da api 
    }

    void _load() async{
      setState(() {
        _isLoading = true;
      });
      try {
        _users = await _userController.fetchAll();
        _filterUsers = _users;

      } catch (e) { 
        // tratar o erro 
        _error = e.toString();
      }
      setState(() {
        _isLoading = false;
      })
    }
    return const Placeholder();
  }

  // Método  para filtragem do lista de usuários 
  void _usersFilter(){
    final query = _userSearch.text.toLowerCase();
    setState(() {
      // filtragem por partes do nome do usuário ou pelo email
      _filterUsers = _users.where((user){
        return user.name.toLowerCase().contains(query) || user.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Método de navegação para a página do cadastro de usuário 
  void _openForm ({UserModel? user}) async { // pode ser para eu criar um novo usuário ou para atualizar o usuário
    await Navigator.push(context, MaterialPageRouter(builder: (context) => UserFormPage(user:user)));
    // Quando eu voltar para a página de listagem de usuario, recarrega a lista de usuarios 
    _load();
  }

  void _delete(UserModel user) async{
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar exclusão"),
        content: Text("Deseja realmente excluir o usuário ${user.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Excluir") )
        ]
      ));
      if(confirm){
        try{
          await _userController.delete(user.id!);
        }catch{
          // mensagem de erro 

        }
      }
  }

  @override 
  Widget build(BuildContext context) {
    return const Scaffold(
      // Não precisa de app bar pq a appbar já ta na home 
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children; [
            TextField(
              controller: _userSearch,
              decoration: InputDecoration(
                labelText: "Pesquisar usuário",
                border: OutlineInputBorder()
              ),
              onChanged: (value) => _usersFilter(), // cada vez que eu digitar uma letra ele usa o textfield
            ),
            SizedBox(height: 16),
            Expanded(child: ListView.builder(
              itemCount: _filterUsers.legth,
              itemBuilder: (contex, index){
                final user = _filterUsers[index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Row(
                      MainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: ()=> _openForm(user:user), icon: Icons(Icons.edit)),
                        IconButton(onPressed: ()=> _delete(user!), icon: Icon(Icons.delete, color: Colors.red))
                      ]
                    )
                  ),
                );
              }))
          ],
        ),)
      FloatActionButton: FloatActionButton(onPressed: () => _openForm(), child? Icon(Icons.add),)    
    );
  }
}