import 'package:flutter_test/flutter_test.dart';
import 'package:tela_perfil/main.dart';

void main() {
  testWidgets('Apenas carrega o perfil', (WidgetTester tester) async {
    // Tenta carregar o app
    await tester.pumpWidget(const TelaPerfil());
  });
}
