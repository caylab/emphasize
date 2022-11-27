import 'package:emphasize/emphasize.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create with all parameters - creation successful', () {
    expect(
      Emphasize(
        text: '',
        words: const <String>[],
        textStyle: const TextStyle(),
        wordStyle: const TextStyle(),
        caseSensitive: false,
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
        softWrap: true,
        overflow: TextOverflow.clip,
        textScaleFactor: 1.0,
        maxLines: 1,
        locale: null,
        strutStyle: StrutStyle.disabled,
        textWidthBasis: TextWidthBasis.parent,
        textHeightBehavior: null,
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
      textStyle: textStyle,
      caseSensitive: false,
      key: UniqueKey(),
    );

    expect(emphasize, isA<Emphasize>());
    expect(emphasize.wordStyle, expectedWordStyle);
  });
}
