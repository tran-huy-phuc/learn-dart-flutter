import 'package:flutter_review/utils/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test capitalize', () {
    final String hello = 'hello';
    expect(hello.capitalize(), 'HELLO');
  });
}
