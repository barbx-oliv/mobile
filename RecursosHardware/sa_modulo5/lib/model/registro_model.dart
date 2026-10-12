class RegistroModel {

  // Atributos
  String? id;
  String dataHora;
  double latitude;
  double longitude;
  String caminhoFoto;
  String observacao;

  // Construtor 
  RegistroModel({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.caminhoFoto,
    required this.observacao
  });

  // mpetodos toMap e FromMap
  Map<String, dynamic> toMap() => {
    "id": id,
    "dataHora": dataHora,
    "latitude": latitude,
    "longitude": longitude,
    "caminhoFoto": caminhoFoto,
    "observacao": observacao
  };

  factory RegistroModel.fromMap(Map<String,dynamic> map)=> 
  RegistroModel(
    id: map["id"].toString(),
    dataHora: map["dataHora"].toString(),
    latitude: map["latitude"],
    longitude: map["longitude"],
    caminhoFoto: map["caminhoFoto"].toString(),
    observacao: map["observacao"]
  );
}