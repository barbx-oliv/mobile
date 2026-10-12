/// Configuração do local de trabalho e raio permitido de registro de ponto (100 metros)
class WorkplaceConfigModel {
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters; // Regra de negócio: limite de 100 metros

  const WorkplaceConfigModel({
    this.name = 'Sede Central - Escritório Matriz',
    this.latitude = -23.550520, // Ponto de referência padrão (São Paulo)
    this.longitude = -46.633308,
    this.radiusMeters = 100.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
    };
  }

  factory WorkplaceConfigModel.fromJson(Map<String, dynamic> map) {
    return WorkplaceConfigModel(
      name: map['name'] as String? ?? 'Sede Central - Escritório Matriz',
      latitude: (map['latitude'] as num?)?.toDouble() ?? -23.550520,
      longitude: (map['longitude'] as num?)?.toDouble() ?? -46.633308,
      radiusMeters: (map['radiusMeters'] as num?)?.toDouble() ?? 100.0,
    );
  }

  WorkplaceConfigModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    double? radiusMeters,
  }) {
    return WorkplaceConfigModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
    );
  }
}
