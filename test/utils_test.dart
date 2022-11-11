import 'package:emphasize/utils.dart';
import 'package:emphasize/word_marker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void expectEqualMarkers(List<WordMarker> actual, List<WordMarker> expected) {
    expect(actual.length, expected.length);

    for (int i = 0; i < actual.length; i++) {
      final WordMarker actualMarker = actual[i];
      final WordMarker expectedMarker = expected[i];
      expect(actualMarker.type, expectedMarker.type, reason: '$MarkerType does not match at item position $i');
      expect(actualMarker.index, expectedMarker.index, reason: '$WordMarker.index does not match at item position $i');
    }
  }

  group('sortByIndex()', () {
    test('empty list - list unchanged', () {
      final List<WordMarker> actual = <WordMarker>[];
      actual.sort(sortByIndex);
      expect(actual, <WordMarker>[]);
    });

    test('one element - list unchanged', () {
      final List<WordMarker> actual = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
      ];
      final List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
      ];

      actual.sort(sortByIndex);

      expectEqualMarkers(actual, expected);
    });

    test('multiple items, sorted - list unchanged', () {
      final List<WordMarker> actual = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 1),
      ];
      final List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 1),
      ];

      actual.sort(sortByIndex);

      expectEqualMarkers(actual, expected);
    });

    test('multiple items, unsorted - list sorted', () {
      final List<WordMarker> actual = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 2),
        WordMarker(type: MarkerType.start, index: 1),
        WordMarker(type: MarkerType.end, index: 3),
      ];
      final List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.start, index: 1),
        WordMarker(type: MarkerType.end, index: 2),
        WordMarker(type: MarkerType.end, index: 3),
      ];

      actual.sort(sortByIndex);

      expectEqualMarkers(actual, expected);
    });

    test('multiple items, unsorted, equal indices - list sorted', () {
      final List<WordMarker> actual = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 2),
        WordMarker(type: MarkerType.start, index: 2),
        WordMarker(type: MarkerType.end, index: 3),
      ];
      final List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.start, index: 2),
        WordMarker(type: MarkerType.end, index: 2),
        WordMarker(type: MarkerType.end, index: 3),
      ];

      actual.sort(sortByIndex);

      expectEqualMarkers(actual, expected);
    });
  });

  group('getRawMarkers()', () {
    test('empty text - returns empty list', () {
      expect(
        getRawMarkers(
          text: '',
          words: <String>[],
          caseSensitive: true,
        ),
        <WordMarker>[],
      );
      expect(
        getRawMarkers(
          text: '',
          words: <String>[],
          caseSensitive: false,
        ),
        <WordMarker>[],
      );
    });

    test('non-empty text, empty words - returns empty list', () {
      const String text = 'test text';

      expect(
        getRawMarkers(
          text: text,
          words: <String>[],
          caseSensitive: true,
        ),
        <WordMarker>[],
      );
      expect(
        getRawMarkers(
          text: text,
          words: <String>[],
          caseSensitive: false,
        ),
        <WordMarker>[],
      );
    });

    test(
        'non-empty text, words contain empty string - '
        'throws AssertionError', () {
      const String text = 'test text';
      final List<String> words = ['test', '', 'text'];

      expect(
        () => getRawMarkers(text: text, words: words),
        throwsAssertionError,
      );
    });

    test('words do not match anything in text - returns empty list', () {
      const String text = 'test text';
      final List<String> words = <String>['tester', 'texter'];

      expect(
        getRawMarkers(
          text: text,
          words: words,
          caseSensitive: false,
        ),
        <WordMarker>[],
      );
    });

    test(
        'word matches whole text - '
        'returns start and end marker with indexes 0 and "length"', () {
      const String text = 'test text';
      final List<String> words = ['test text'];

      final List<WordMarker> actual = getRawMarkers(
        text: text,
        words: words,
        caseSensitive: false,
      );

      final List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: text.length),
      ];

      expectEqualMarkers(actual, expected);
    });

    test(
        'word matches a single text part - '
        'returns start and end marker for that match', () {
      const String text = 'test text abc';
      List<String> words = <String>['text'];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 9),
      ];

      List<WordMarker> actual = getRawMarkers(
        text: text,
        words: words,
        caseSensitive: false,
      );

      expectEqualMarkers(actual, expected);
    });

    test(
        'word matches a single text part, case-sensitively - '
        'returns start and end marker for that match', () {
      const String text = 'test text abc test Text abc';
      List<String> words = <String>['text'];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 9),
      ];

      List<WordMarker> actual = getRawMarkers(
        text: text,
        words: words,
        caseSensitive: true,
      );

      expectEqualMarkers(actual, expected);
    });

    test(
        'word matches multiple text parts - '
        'returns start and end marker for each match in order of appearance', () {
      const String text = 'test text abc test text abc';
      List<String> words = <String>['text'];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 9),
        WordMarker(type: MarkerType.start, index: 19),
        WordMarker(type: MarkerType.end, index: 23),
      ];

      List<WordMarker> actual = getRawMarkers(
        text: text,
        words: words,
        caseSensitive: false,
      );

      expectEqualMarkers(actual, expected);
    });

    test(
        'two words match overlapping text parts - '
        'returns start and end marker for each word', () {
      const String text = 'test text abc test text abc';
      List<String> words = <String>['text abc', 'abc test'];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 13),
        WordMarker(type: MarkerType.start, index: 19),
        WordMarker(type: MarkerType.end, index: 27),
        WordMarker(type: MarkerType.start, index: 10),
        WordMarker(type: MarkerType.end, index: 18),
      ];

      List<WordMarker> actual = getRawMarkers(
        text: text,
        words: words,
        caseSensitive: false,
      );

      expectEqualMarkers(actual, expected);
    });
  });

  group('getBlockMarkers()', () {
    test('empty raw markers - returns empty block markers', () {
      List<WordMarker> rawMarkers = <WordMarker>[];
      List<WordMarker> expected = <WordMarker>[];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expect(actual, expected);
    });

    test('one raw marker - returns marker unchanged', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test('two raw markers - returns markers unchanged', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 10),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 10),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test(
        'two blocks, not overlapping - '
        'returns markers in ascending order', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 15),
        WordMarker(type: MarkerType.end, index: 20),
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 10),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 10),
        WordMarker(type: MarkerType.start, index: 15),
        WordMarker(type: MarkerType.end, index: 20),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test(
        'two blocks edge to edge - '
        'returns start and end markers of the merged block', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 10),
        WordMarker(type: MarkerType.start, index: 10),
        WordMarker(type: MarkerType.end, index: 20),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 20),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test(
        'two blocks, overlapping - '
        'returns start and end markers of the merged block', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 15),
        WordMarker(type: MarkerType.start, index: 10),
        WordMarker(type: MarkerType.end, index: 20),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 20),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test(
        'two blocks, one embedded in the other, at the edge - '
        'returns start and end markers of the surrounding block', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 20),
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 10),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 20),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });

    test(
        'two blocks, one embedded in the other, not at the edge - '
        'returns start and end markers of the surrounding block', () {
      List<WordMarker> rawMarkers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 20),
        WordMarker(type: MarkerType.start, index: 5),
        WordMarker(type: MarkerType.end, index: 10),
      ];
      List<WordMarker> expected = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 0),
        WordMarker(type: MarkerType.end, index: 20),
      ];

      List<WordMarker> actual = getBlockMarkers(rawMarkers);

      expectEqualMarkers(actual, expected);
    });
  });

  group('getMarkedText()', () {
    test('too few or too many tags - throws AssertionError', () {
      expect(
        () => getMarkedText(text: '', markers: <WordMarker>[], tags: '['),
        throwsAssertionError,
      );
      expect(
        () => getMarkedText(text: '', markers: <WordMarker>[], tags: '[]]'),
        throwsAssertionError,
      );
    });

    test('empty string, no markers - returns empty string', () {
      expect(getMarkedText(text: '', markers: <WordMarker>[]), '');
    });

    test('empty string, wrong markers - throws exception', () {
      List<WordMarker> markers = <WordMarker>[
        WordMarker(type: MarkerType.start, index: 1),
      ];

      expect(
        () => getMarkedText(text: '', markers: markers),
        throwsRangeError,
      );
    });
  });

  // group('getStyleByTextPart()', () {
  //   test('', () {
  //
  //   });
  // });
}
