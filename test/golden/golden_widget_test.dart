import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wyly/screen/home_screen.dart';
import '../helper.dart' as helper;

void main() {
  testWidgets('home', (tester) async {
    await tester.pumpWidget(helper.buildTestableWidget(HomeScreen()));
    await expectLater(find.byType(HomeScreen), matchesGoldenFile('home.png'),
        skip: !Platform.isMacOS);
  });
}
