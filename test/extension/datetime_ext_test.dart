import 'package:flutter_test/flutter_test.dart';
import 'package:wyly/extension/datetime_ext.dart';

void main() {
  final datetime = DateTime(2020, 2, 28, 21, 33);
  group('toDateTimeString', () {
    test('正常系', () {
      expect(datetime.toDateTimeString(), '2020/02/28 21:33');
    });
  });
  group('toDateString', () {
    test('正常系', () {
      expect(datetime.toDateString(), '2020/02/28');
    });
  });
}
