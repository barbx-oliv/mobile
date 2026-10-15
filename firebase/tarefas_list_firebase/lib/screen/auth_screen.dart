import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import "package:tarefas_list_firebase/screen/login_screen.dart";

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Vai verificar o estado de autenticação e redirecionar 
      // para tarefas se já estiver logado ou logjn se não estiver logado
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot){
        if (snapshot.hasData){
          return TarefaScreen();
        }
        return LoginScreen();
      });
  }
}