/// Modelo que representa o Funcionário da empresa
class EmployeeModel {
  final String id;
  final String nif; // Número de Identificação do Funcionário
  final String name;
  final String email;
  final String role;
  final String department;
  final bool biometricEnabled;

  const EmployeeModel({
    required this.id,
    required this.nif,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    this.biometricEnabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nif': nif,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'biometricEnabled': biometricEnabled,
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as String? ?? '',
      nif: map['nif'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? '',
      department: map['department'] as String? ?? '',
      biometricEnabled: map['biometricEnabled'] as bool? ?? true,
    );
  }

  EmployeeModel copyWith({
    String? id,
    String? nif,
    String? name,
    String? email,
    String? role,
    String? department,
    bool? biometricEnabled,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      nif: nif ?? this.nif,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
