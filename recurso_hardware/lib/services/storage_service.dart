import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee_model.dart';
import '../models/time_record_model.dart';
import '../models/workplace_config_model.dart';
import '../utils/constants.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Usuário Logado ---
  Future<void> saveUser(EmployeeModel employee) async {
    await init();
    await _prefs!.setString(AppConstants.keyLoggedUser, jsonEncode(employee.toJson()));
  }

  Future<EmployeeModel?> getSavedUser() async {
    await init();
    final jsonStr = _prefs!.getString(AppConstants.keyLoggedUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return EmployeeModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await init();
    await _prefs!.remove(AppConstants.keyLoggedUser);
  }

  // --- NIF ou Email Lembrado para Biometria ---
  Future<void> saveRememberedIdentifier(String identifier) async {
    await init();
    await _prefs!.setString(AppConstants.keyRememberNif, identifier);
  }

  Future<String?> getRememberedIdentifier() async {
    await init();
    return _prefs!.getString(AppConstants.keyRememberNif);
  }

  // --- Configuração do Local de Trabalho ---
  Future<void> saveWorkplaceConfig(WorkplaceConfigModel config) async {
    await init();
    await _prefs!.setString(AppConstants.keyWorkplaceConfig, jsonEncode(config.toJson()));
  }

  Future<WorkplaceConfigModel> getWorkplaceConfig() async {
    await init();
    final jsonStr = _prefs!.getString(AppConstants.keyWorkplaceConfig);
    if (jsonStr == null || jsonStr.isEmpty) {
      return AppConstants.defaultWorkplace;
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return WorkplaceConfigModel.fromJson(map);
    } catch (_) {
      return AppConstants.defaultWorkplace;
    }
  }

  // --- Histórico de Registros de Ponto (Offline-first) ---
  Future<void> saveTimeRecord(TimeRecordModel record) async {
    await init();
    final records = await getTimeRecords();
    // Insere no início da lista (ordem cronológica decrescente)
    records.insert(0, record);
    final jsonList = records.map((r) => r.toJson()).toList();
    await _prefs!.setString(AppConstants.keyTimeRecords, jsonEncode(jsonList));
  }

  Future<List<TimeRecordModel>> getTimeRecords() async {
    await init();
    final jsonStr = _prefs!.getString(AppConstants.keyTimeRecords);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((item) => TimeRecordModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updateTimeRecord(TimeRecordModel updated) async {
    await init();
    final records = await getTimeRecords();
    final index = records.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      records[index] = updated;
      final jsonList = records.map((r) => r.toJson()).toList();
      await _prefs!.setString(AppConstants.keyTimeRecords, jsonEncode(jsonList));
    }
  }

  Future<void> clearAllRecords() async {
    await init();
    await _prefs!.remove(AppConstants.keyTimeRecords);
  }
}
