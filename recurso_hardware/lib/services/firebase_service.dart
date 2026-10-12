import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/employee_model.dart';
import '../models/time_record_model.dart';

class FirebaseService {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  /// Tenta inicializar o Firebase Core de forma segura
  Future<bool> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isInitialized = true;
      } else {
        // Tenta inicialização padrão (funciona se houver google-services.json ou options configurados)
        await Firebase.initializeApp();
        _isInitialized = true;
      }

      if (_isInitialized) {
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        debugPrint('Firebase inicializado com sucesso!');
        return true;
      }
    } catch (e) {
      debugPrint('Aviso: Firebase não configurado nesta máquina ou ambiente: $e');
      _isInitialized = false;
    }
    return false;
  }

  /// Autenticação com Email e Senha no Firebase Auth
  Future<UserCredential?> signInWithFirebase(String email, String password) async {
    if (!_isInitialized || _auth == null) {
      return null;
    }
    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      debugPrint('Erro Firebase Auth signIn: $e');
      rethrow;
    }
  }

  /// Cadastro de novo usuário no Firebase Auth
  Future<UserCredential?> signUpWithFirebase(String email, String password) async {
    if (!_isInitialized || _auth == null) {
      return null;
    }
    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      debugPrint('Erro Firebase Auth signUp: $e');
      rethrow;
    }
  }

  /// Salva registro de ponto no Cloud Firestore em tempo real
  Future<bool> saveRecordToFirestore(TimeRecordModel record) async {
    if (!_isInitialized || _firestore == null) {
      debugPrint('Firestore não inicializado. Registro mantido localmente.');
      return false;
    }
    try {
      await _firestore!
          .collection('registros_ponto')
          .doc(record.id)
          .set(record.toJson());
      debugPrint('Registro de ponto sincronizado com o Cloud Firestore: ${record.id}');
      return true;
    } catch (e) {
      debugPrint('Erro ao salvar no Firestore: $e');
      return false;
    }
  }

  /// Salva ou atualiza perfil de funcionário no Firestore
  Future<bool> saveEmployeeProfile(EmployeeModel employee) async {
    if (!_isInitialized || _firestore == null) return false;
    try {
      await _firestore!
          .collection('funcionarios')
          .doc(employee.id)
          .set(employee.toJson());
      return true;
    } catch (e) {
      debugPrint('Erro ao salvar funcionário no Firestore: $e');
      return false;
    }
  }

  /// Busca registros de ponto em tempo real do Cloud Firestore
  Stream<List<TimeRecordModel>>? streamTimeRecords(String employeeId) {
    if (!_isInitialized || _firestore == null) {
      return null;
    }
    return _firestore!
        .collection('registros_ponto')
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TimeRecordModel.fromJson(doc.data())).toList();
    });
  }

  /// Desconectar da conta Firebase
  Future<void> signOut() async {
    if (_isInitialized && _auth != null) {
      await _auth!.signOut();
    }
  }
}
