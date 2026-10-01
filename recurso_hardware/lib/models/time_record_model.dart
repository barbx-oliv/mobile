import 'package:flutter/material.dart';

/// Tipos de batida de ponto
enum TimeRecordType {
  entry, // Entrada
  lunchOut, // Saída para intervalo/almoço
  lunchIn, // Retorno do intervalo
  exit, // Saída fim do expediente
}

extension TimeRecordTypeExtension on TimeRecordType {
  String get label {
    switch (this) {
      case TimeRecordType.entry:
        return 'Entrada';
      case TimeRecordType.lunchOut:
        return 'Saída Intervalo';
      case TimeRecordType.lunchIn:
        return 'Volta Intervalo';
      case TimeRecordType.exit:
        return 'Saída Expediente';
    }
  }

  IconData get icon {
    switch (this) {
      case TimeRecordType.entry:
        return Icons.login_rounded;
      case TimeRecordType.lunchOut:
        return Icons.restaurant_rounded;
      case TimeRecordType.lunchIn:
        return Icons.work_history_rounded;
      case TimeRecordType.exit:
        return Icons.logout_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TimeRecordType.entry:
        return const Color(0xFF1B8755); // Verde
      case TimeRecordType.lunchOut:
        return const Color(0xFFD97706); // Laranja
      case TimeRecordType.lunchIn:
        return const Color(0xFF2563EB); // Azul
      case TimeRecordType.exit:
        return const Color(0xFFDC2626); // Vermelho
    }
  }
}

/// Métodos de autenticação utilizados na batida
enum AuthMethod {
  biometric, // Biometria / Reconhecimento Facial
  password, // NIF / Senha
}

extension AuthMethodExtension on AuthMethod {
  String get label {
    switch (this) {
      case AuthMethod.biometric:
        return 'Reconhecimento Facial / Biometria';
      case AuthMethod.password:
        return 'Senha / NIF';
    }
  }

  IconData get icon {
    switch (this) {
      case AuthMethod.biometric:
        return Icons.face_unlock_rounded;
      case AuthMethod.password:
        return Icons.lock_outline_rounded;
    }
  }
}

/// Modelo do Registro de Ponto
class TimeRecordModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String employeeNif;
  final DateTime timestamp;
  final TimeRecordType type;
  final double latitude;
  final double longitude;
  final double distanceToWorkplace;
  final bool isWithinRadius;
  final AuthMethod authMethod;
  final bool syncedToFirebase;

  const TimeRecordModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeNif,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceToWorkplace,
    required this.isWithinRadius,
    required this.authMethod,
    this.syncedToFirebase = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeeNif': employeeNif,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'latitude': latitude,
      'longitude': longitude,
      'distanceToWorkplace': distanceToWorkplace,
      'isWithinRadius': isWithinRadius,
      'authMethod': authMethod.name,
      'syncedToFirebase': syncedToFirebase,
    };
  }

  factory TimeRecordModel.fromJson(Map<String, dynamic> map) {
    return TimeRecordModel(
      id: map['id'] as String? ?? '',
      employeeId: map['employeeId'] as String? ?? '',
      employeeName: map['employeeName'] as String? ?? '',
      employeeNif: map['employeeNif'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
      type: TimeRecordType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TimeRecordType.entry,
      ),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceToWorkplace: (map['distanceToWorkplace'] as num?)?.toDouble() ?? 0.0,
      isWithinRadius: map['isWithinRadius'] as bool? ?? false,
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name == map['authMethod'],
        orElse: () => AuthMethod.password,
      ),
      syncedToFirebase: map['syncedToFirebase'] as bool? ?? false,
    );
  }

  TimeRecordModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? employeeNif,
    DateTime? timestamp,
    TimeRecordType? type,
    double? latitude,
    double? longitude,
    double? distanceToWorkplace,
    bool? isWithinRadius,
    AuthMethod? authMethod,
    bool? syncedToFirebase,
  }) {
    return TimeRecordModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeNif: employeeNif ?? this.employeeNif,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceToWorkplace: distanceToWorkplace ?? this.distanceToWorkplace,
      isWithinRadius: isWithinRadius ?? this.isWithinRadius,
      authMethod: authMethod ?? this.authMethod,
      syncedToFirebase: syncedToFirebase ?? this.syncedToFirebase,
    );
  }
}
