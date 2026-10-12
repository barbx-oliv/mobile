import 'package:flutter/material.dart';
import 'package:api_cine/controller/home_controller.dart';
import 'package:api_cine/controller/favorites_controller.dart';
import 'package:api_cine/model/movie_model.dart';
import 'package:api_cine/view/favorites_page.dart';

class HomeView extends StatefulWidget {
  final String userName;
  const HomeView({super.key, required this.userName});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _homeController = HomeController();
  final FavoritesController _favoritesController = FavoritesController();
  
  List<Movie> _movies = [];
  bool _isLoading = false;

  void _search(String query) async {
    setState(() => _isLoading = true);
    final results = await _homeController.searchMovies(query);
    setState(() {
      _movies = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesView()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar filme...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _search,
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  final imageUrl = movie.posterPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                      : 'https://via.placeholder.com/150';

                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () async {
                            await _favoritesController.addFavorite(movie);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Filme adicionado aos favoritos!')),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}