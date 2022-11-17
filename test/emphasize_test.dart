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

  test('create without wordStyle - wordStyle inferred from textStyle', () {
    const TextStyle textStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.normal,
    );
    const TextStyle expectedWordStyle = TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    );

    final Emphasize emphasize = Emphasize(
      text: '',
      words: const <String>[],
      caseSensitive: false,
      textStyle: textStyle,
      key: UniqueKey(),
    );

    expect(emphasize, isA<Emphasize>());
    expect(emphasize.wordStyle, expectedWordStyle);
  });
}
