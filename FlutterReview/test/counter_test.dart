import 'package:flutter_review/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Counter counter = Counter();
  setUp(() {
    // counter = Counter();
  });

  test('Test initial value', () {
    expect(counter.value, 0);
  });

  test('Test increment', () {
    counter.increment();
    expect(counter.value, 1);
  });

  test('Test decrement', () {
    counter.decrement();

    expect(counter.value, 0);
  });
}