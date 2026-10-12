import 'package:flutter/material.dart';
import 'package:api_cine/view/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineFavorite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      // A primeira tela do app deve ser o Login (conforme o briefing)
      home: LoginView(),
    );
  }
}
