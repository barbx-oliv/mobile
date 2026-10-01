import '../models/employee_model.dart';
import '../models/workplace_config_model.dart';

class AppConstants {
  static const String appName = 'PontoGeo & Bio';
  static const String appVersion = '1.0.0';

  // Chaves de armazenamento local (SharedPreferences)
  static const String keyLoggedUser = 'logged_employee_data';
  static const String keyWorkplaceConfig = 'workplace_config';
  static const String keyTimeRecords = 'time_records_list';
  static const String keyBiometricEnabled = 'biometric_enabled_flag';
  static const String keyRememberNif = 'remembered_nif_or_email';

  // Configuração padrão do local de trabalho (Sede da Empresa)
  // Raio de 100m exigido pela especificação
  static const WorkplaceConfigModel defaultWorkplace = WorkplaceConfigModel(
    name: 'Sede Central - Tech Hub',
    latitude: -23.550520, // Marco Zero / Centro de SP
    longitude: -46.633308,
    radiusMeters: 100.0,
  );

  // Usuários de teste pré-cadastrados (permitindo acesso via NIF ou Email com senha '123456')
  static const List<Map<String, dynamic>> mockUsers = [
    {
      'nif': '1001',
      'email': 'carlos.silva@empresa.com.br',
      'password': '123',
      'employee': EmployeeModel(
        id: 'emp-001',
        nif: '1001',
        name: 'Carlos Silva',
        email: 'carlos.silva@empresa.com.br',
        role: 'Desenvolvedor Flutter Junior',
        department: 'Engenharia Mobile',
        biometricEnabled: true,
      ),
    },
    {
      'nif': '1002',
      'email': 'mariana.costa@empresa.com.br',
      'password': '123',
      'employee': EmployeeModel(
        id: 'emp-002',
        nif: '1002',
        name: 'Mariana Costa',
        email: 'mariana.costa@empresa.com.br',
        role: 'Analista de QA',
        department: 'Qualidade de Software',
        biometricEnabled: true,
      ),
    },
    {
      'nif': '1003',
      'email': 'andre.souza@empresa.com.br',
      'password': '123',
      'employee': EmployeeModel(
        id: 'emp-003',
        nif: '1003',
        name: 'André Souza',
        email: 'andre.souza@empresa.com.br',
        role: 'Gerente de Projetos',
        department: 'Operações',
        biometricEnabled: true,
      ),
    },
  ];
}
