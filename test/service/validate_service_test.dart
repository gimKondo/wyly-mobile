import 'package:flutter_test/flutter_test.dart';
import 'package:wyly/service/validate_service.dart';

void main() {
  group('isValidEmail', () {
    test('正しいE-mail', () {
      expect(isValidEmai('test@example.com'), true);
    });
    test('空文字', () {
      expect(isValidEmai(''), false);
    });
    test('ドメインなし', () {
      expect(isValidEmai('test@'), false);
    });
    test('ユーザ名なし', () {
      expect(isValidEmai('@example.com'), false);
    });
    test('@なし', () {
      expect(isValidEmai('test.example.com'), false);
    });
  });
}
