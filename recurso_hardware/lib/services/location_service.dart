import 'package:geolocator/geolocator.dart';
import '../models/workplace_config_model.dart';

class LocationResult {
  final bool success;
  final Position? position;
  final double? distanceMeters;
  final bool isWithinRadius;
  final String? errorMessage;

  LocationResult({
    required this.success,
    this.position,
    this.distanceMeters,
    this.isWithinRadius = false,
    this.errorMessage,
  });
}

class LocationService {
  /// Verifica se os serviços de GPS estão habilitados no dispositivo
  Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Verifica e solicita permissões de localização
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Obtém a posição atual do funcionário e calcula a distância até o local de trabalho
  Future<LocationResult> checkLocationAndDistance(WorkplaceConfigModel workplace) async {
    try {
      final serviceEnabled = await isGpsEnabled();
      if (!serviceEnabled) {
        return LocationResult(
          success: false,
          errorMessage: 'O GPS está desativado no aparelho. Por favor, ative a localização nas configurações.',
        );
      }

      LocationPermission permission = await checkAndRequestPermission();

      if (permission == LocationPermission.denied) {
        return LocationResult(
          success: false,
          errorMessage: 'Permissão de localização negada pelo usuário.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult(
          success: false,
          errorMessage: 'A permissão de localização foi negada permanentemente. É necessário liberar nas configurações do sistema.',
        );
      }

      // Obtém a coordenada atual com alta precisão
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Calcula a distância geodésica em metros até a empresa
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        workplace.latitude,
        workplace.longitude,
      );

      final isWithin = distance <= workplace.radiusMeters;

      return LocationResult(
        success: true,
        position: position,
        distanceMeters: distance,
        isWithinRadius: isWithin,
      );
    } catch (e) {
      return LocationResult(
        success: false,
        errorMessage: 'Falha ao obter localização: ${e.toString()}',
      );
    }
  }

  /// Abre as configurações do sistema para o usuário ativar a localização
  Future<bool> openSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Abre as permissões do aplicativo
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}
