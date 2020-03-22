import 'package:flutter_test/flutter_test.dart';
import 'package:wyly/main.dart';

void main() {
  testWidgets('Golden test', (tester) async {
    await tester.pumpWidget(MyApp());
    await expectLater(find.byType(MyApp), matchesGoldenFile('main.png'));
  });
}
