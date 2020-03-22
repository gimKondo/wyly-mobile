import 'package:flutter_test/flutter_test.dart';
import './screen_size_golden.dart';
import 'package:wyly/main.dart';

void main() {
  testWidgets('Golden test', (tester) async {
    await tester.setScreenSize(width: 2160, height: 1080);
    await tester.pumpWidget(MyApp());
    await expectLater(find.byType(MyApp), matchesGoldenFile('main.png'));
  });
}
