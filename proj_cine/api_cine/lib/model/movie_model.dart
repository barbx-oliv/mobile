class MovieModel {
  // atributos
  final String? id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final String rating;

  MovieModel({
    this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
    required this.releaseDate,
  });

  Map<String, dynamic> toMap() =>{
    "id": id,
    "title": title,
    "posterPath": posterPath,
    "overview": overview,
    "releaseDate": releaseDate,
    "rating": rating
  };

  factory MovieModel.fromMap(Map<String,dynamic> map) => 
  MovieModel(
    id: ["id"].toString(),
    title: ["title"].toString(), 
    posterPath: ["posterPath"].toString(), 
    rating: ["rating"].toString(),
    overview: ["overview"].toString(),
    releaseDate: ["releaseDate"].toString()
    );
}