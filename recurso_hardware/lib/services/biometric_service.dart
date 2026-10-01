import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricResult {
  final bool authenticated;
  final String? errorMessage;
  final bool notAvailable;

  BiometricResult({
    required this.authenticated,
    this.errorMessage,
    this.notAvailable = false,
  });
}

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Verifica se o dispositivo possui hardware biométrico e suporte
  Future<bool> isBiometricsSupported() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  /// Retorna os tipos de biometria cadastrados no aparelho (Face, Fingerprint, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Realiza a autenticação biométrica (Reconhecimento Facial ou Impressão Digital)
  Future<BiometricResult> authenticate({
    String reason = 'Confirme sua identidade via biometria/reconhecimento facial para registrar o ponto.',
  }) async {
    try {
      final isSupported = await isBiometricsSupported();
      if (!isSupported) {
        return BiometricResult(
          authenticated: false,
          notAvailable: true,
          errorMessage: 'Dispositivo sem suporte ou sem biometria cadastrada no sistema.',
        );
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      return BiometricResult(
        authenticated: didAuthenticate,
        errorMessage: didAuthenticate ? null : 'Autenticação biométrica cancelada ou não reconhecida.',
      );
    } on PlatformException catch (e) {
      String message = 'Erro na biometria: ${e.message ?? e.code}';
      if (e.code == 'NotAvailable') {
        message = 'Biometria não disponível ou desativada nas configurações do aparelho.';
      } else if (e.code == 'NotEnrolled') {
        message = 'Nenhuma biometria ou reconhecimento facial cadastrado no aparelho.';
      } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        message = 'Biometria bloqueada por excesso de tentativas. Desbloqueie com sua senha do aparelho.';
      }
      return BiometricResult(
        authenticated: false,
        notAvailable: true,
        errorMessage: message,
      );
    } catch (e) {
      return BiometricResult(
        authenticated: false,
        errorMessage: 'Erro inesperado na validação biométrica: ${e.toString()}',
      );
    }
  }

  /// Cancela qualquer autenticação biométrica em andamento
  Future<void> cancelAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }
}
