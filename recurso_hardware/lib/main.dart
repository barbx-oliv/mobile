import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_provider.dart';
import 'controllers/time_clock_provider.dart';
import 'services/biometric_service.dart';
import 'services/firebase_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'views/login_screen.dart';
import 'views/main_navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa formatação de datas e horários em Português do Brasil (pt_BR)
  try {
    await initializeDateFormatting('pt_BR', null);
  } catch (e) {
    debugPrint('Aviso ao inicializar locale pt_BR: $e');
  }

  // Inicialização dos serviços fundamentais
  final storageService = StorageService();
  await storageService.init();

  final biometricService = BiometricService();
  final locationService = LocationService();
  final firebaseService = FirebaseService();

  // Inicializa Firebase com tratamento resiliente
  await firebaseService.initialize();

  runApp(
    PontoApp(
      storageService: storageService,
      biometricService: biometricService,
      locationService: locationService,
      firebaseService: firebaseService,
    ),
  );
}

class PontoApp extends StatelessWidget {
  final StorageService storageService;
  final BiometricService biometricService;
  final LocationService locationService;
  final FirebaseService firebaseService;

  const PontoApp({
    super.key,
    required this.storageService,
    required this.biometricService,
    required this.locationService,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<BiometricService>.value(value: biometricService),
        Provider<LocationService>.value(value: locationService),
        Provider<FirebaseService>.value(value: firebaseService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            storageService: storageService,
            biometricService: biometricService,
            firebaseService: firebaseService,
          )..initialize(),
        ),
        ChangeNotifierProvider<TimeClockProvider>(
          create: (_) => TimeClockProvider(
            storageService: storageService,
            locationService: locationService,
            biometricService: biometricService,
            firebaseService: firebaseService,
          )..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'PontoGeo & Bio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Enquanto carrega os dados locais
    if (auth.isLoading && auth.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Se estiver autenticado, vai para a navegação principal
    if (auth.isAuthenticated) {
      return const MainNavigationShell();
    }

    // Caso contrário, vai para a tela de login
    return const LoginScreen();
  }
}

/// Compatibilidade com widget tests padrão do Flutter
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('$_counter'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _counter++),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
