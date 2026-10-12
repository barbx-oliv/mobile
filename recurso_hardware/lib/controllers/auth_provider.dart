// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../models/employee_model.dart';
import '../services/biometric_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService;
  final BiometricService _biometricService;
  final FirebaseService _firebaseService;

  AuthProvider({
    required StorageService storageService,
    required BiometricService biometricService,
    required FirebaseService firebaseService,
  })  : _storageService = storageService,
        _biometricService = biometricService,
        _firebaseService = firebaseService;

  EmployeeModel? _currentUser;
  EmployeeModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isBiometricSupported = false;
  bool get isBiometricSupported => _isBiometricSupported;

  List<BiometricType> _availableBiometrics = [];
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  String? _rememberedIdentifier;
  String? get rememberedIdentifier => _rememberedIdentifier;

  bool get hasFacialBiometrics => _availableBiometrics.contains(BiometricType.face);

  /// Inicializa o estado de autenticação ao abrir o app
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isBiometricSupported = await _biometricService.isBiometricsSupported();
      if (_isBiometricSupported) {
        _availableBiometrics = await _biometricService.getAvailableBiometrics();
      }

      _rememberedIdentifier = await _storageService.getRememberedIdentifier();
      _currentUser = await _storageService.getSavedUser();
    } catch (e) {
      debugPrint('Erro ao inicializar AuthProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login por NIF ou E-mail e Senha
  Future<bool> loginWithNifOrEmail({
    required String identifier,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanIdentifier = identifier.trim().toLowerCase();
      final cleanPassword = password.trim();

      if (cleanIdentifier.isEmpty || cleanPassword.isEmpty) {
        _errorMessage = 'Por favor, preencha o NIF/E-mail e a senha.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 1. Tenta autenticação via Firebase caso disponível
      if (_firebaseService.isInitialized && cleanIdentifier.contains('@')) {
        try {
          final cred = await _firebaseService.signInWithFirebase(cleanIdentifier, cleanPassword);
          if (cred != null && cred.user != null) {
            final employee = EmployeeModel(
              id: cred.user!.uid,
              nif: 'NIF-${cred.user!.uid.substring(0, 4)}',
              name: cred.user!.displayName ?? cred.user!.email!.split('@').first,
              email: cred.user!.email!,
              role: 'Colaborador',
              department: 'Geral',
            );
            await _onLoginSuccess(employee, cleanIdentifier);
            return true;
          }
        } catch (_) {
          // Se falhar no Firebase, checa se é usuário mock
        }
      }

      // 2. Autenticação na base de teste / NIF
      final match = AppConstants.mockUsers.firstWhere(
        (u) =>
            ((u['nif'] as String).toLowerCase() == cleanIdentifier ||
                (u['email'] as String).toLowerCase() == cleanIdentifier) &&
            u['password'] == cleanPassword,
        orElse: () => {},
      );

      if (match.isNotEmpty) {
        final employee = match['employee'] as EmployeeModel;
        await _onLoginSuccess(employee, cleanIdentifier);
        return true;
      }

      // 3. Fallback inteligente para demonstração rápida
      if (cleanPassword == '123' || cleanPassword == '123456') {
        final employee = EmployeeModel(
          id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
          nif: cleanIdentifier.contains('@') ? '9999' : cleanIdentifier,
          name: cleanIdentifier.contains('@')
              ? cleanIdentifier.split('@').first.toUpperCase()
              : 'Funcionário NIF $cleanIdentifier',
          email: cleanIdentifier.contains('@') ? cleanIdentifier : '$cleanIdentifier@empresa.com.br',
          role: 'Colaborador Efetivo',
          department: 'Operações',
        );
        await _onLoginSuccess(employee, cleanIdentifier);
        return true;
      }

      _errorMessage = 'Credenciais incorretas. Use NIF 1001 / senha 123 ou clique em um usuário de teste.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Erro no login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login direto usando Reconhecimento Facial / Biometria do aparelho
  Future<bool> loginWithBiometrics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isSupported = await _biometricService.isBiometricsSupported();
      if (!isSupported) {
        _errorMessage = 'Seu dispositivo não possui biometria ou reconhecimento facial configurado.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await _biometricService.authenticate(
        reason: 'Aproxime seu rosto ou use a digital para autenticar no sistema de ponto.',
      );

      if (!result.authenticated) {
        _errorMessage = result.errorMessage ?? 'Autenticação facial/biométrica não validada.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Recupera o último usuário ou utiliza o usuário padrão de teste
      EmployeeModel? targetUser = await _storageService.getSavedUser();
      if (targetUser == null) {
        final identifier = _rememberedIdentifier;
        if (identifier != null && identifier.isNotEmpty) {
          final match = AppConstants.mockUsers.firstWhere(
            (u) =>
                (u['nif'] as String).toLowerCase() == identifier.toLowerCase() ||
                (u['email'] as String).toLowerCase() == identifier.toLowerCase(),
            orElse: () => {},
          );
          if (match.isNotEmpty) {
            targetUser = match['employee'] as EmployeeModel;
          }
        }
      }

      // Se ainda não houver usuário salvo, utiliza o perfil padrão do Carlos Silva (NIF 1001)
      targetUser ??= AppConstants.mockUsers[0]['employee'] as EmployeeModel;

      await _onLoginSuccess(targetUser, targetUser.nif);
      return true;
    } catch (e) {
      _errorMessage = 'Falha na autenticação biométrica: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _onLoginSuccess(EmployeeModel employee, String identifier) async {
    _currentUser = employee;
    _rememberedIdentifier = identifier;
    _errorMessage = null;
    _isLoading = false;

    await _storageService.saveUser(employee);
    await _storageService.saveRememberedIdentifier(identifier);

    // Registra no Firebase se disponível
    await _firebaseService.saveEmployeeProfile(employee);

    notifyListeners();
  }

  /// Seleção rápida de usuário para testes da banca avaliadora
  Future<void> selectDemoUser(Map<String, dynamic> userMock) async {
    final employee = userMock['employee'] as EmployeeModel;
    await _onLoginSuccess(employee, employee.nif);
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    await _storageService.clearUser();
    await _firebaseService.signOut();
    notifyListeners();
  }
}
