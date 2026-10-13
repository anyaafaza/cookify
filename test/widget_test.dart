import 'package:flutter_test/flutter_test.dart';
import 'package:cookify/main.dart';

void main() {
  testWidgets('Cookify smoke test', (tester) async {
    await tester.pumpWidget(const CookifyApp());
    expect(find.text('Selamat Datang'), findsOneWidget);
  });
}
