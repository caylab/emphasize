import 'package:emphasize/emphasize.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create with all parameters - creation successful', () {
    expect(
      Emphasize(
        text: '',
        words: const <String>[],
        caseSensitive: false,
        textStyle: const TextStyle(),
        wordStyle: const TextStyle(),
        key: UniqueKey(),
      ),
      isA<Emphasize>(),
    );
  });
}
