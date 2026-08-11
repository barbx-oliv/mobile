import 'package:flutter/material.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
    // Controlador das mudanças na base de dados(criação/atualização/delete)
    final ValueNotifier<int> _notifier = ValueNotifier<int>(0);
    //Chama a classe de controller de livros 
    final BookController _bookController = BookController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, _, __) {
                return FutureBuilder(
                    future: _bookController.fetchAll(),
                    builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) { // enquanto estabelece conexão o banco de dados, mostra um loading
                            return const Center(child: CircularProgressIndicator()); // vai ficar aparecendo o loading enquanto não tiver resposta do backend
                        }
                        if(snapshot.hasError) {
                            return Center(
                                child: Column (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.error_outline, size: 60, color: Colors.red),
                                        SizedBox(height: 16),
                                        // Botão para recarregar página
                                    ],
                                ),
                            );
                        }
                        final books = snapshot.data ?? [];
                        if (books.isEmpty) {
                            return const Center(child: Text("Nenhum livro na lista"));
                        }
                        return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                                return Card();
                            }
                        )
                        )
                    })
        }),
    );
  }
}