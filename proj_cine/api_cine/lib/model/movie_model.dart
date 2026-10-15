
class Movie {
  final int id;
  final String title;
  final String posterPath;
  double? rating;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating,
  });

  // Converte o JSON que vem da API do TMDB em Objeto
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Sem Título',
      posterPath: json['poster_path'] ?? '',
      rating: 0.0,
    );
  }

  // Converte o dado que vem do SQLite em Objeto
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      rating: map['rating'],
    );
  }

  // Converte o Objeto para Map (para salvar no SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
    };
  }
}