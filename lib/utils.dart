import 'package:flutter/material.dart';

import 'word_marker.dart';

/// Used to sorts [WordMarker]s by their index, ascending.<br/>
/// If indexes are identical and marker types are different,
/// the start marker comes first and the end marker comes second,
/// making the resp. blocks intersect/overlap at that position.
int sortByIndex(final WordMarker a, final WordMarker b) {
  final int compareResult = a.index.compareTo(b.index);

  if (compareResult == 0) {
    if (a.type == b.type) {
      return compareResult; // order does not matter
    } else if (a.type == MarkerType.start) {
      return 1; // end marker comes first
    } else {
      return -1; // start marker comes second
    }
  } else {
    return compareResult;
  }
}

/// Gets the [WordMarker]s representing the start and end of all given [words]
/// in the given [text]. This may include overlapping and embedded words.<br/>
List<WordMarker> getRawMarkers({
  required final String text,
  required final Iterable<String> words,
  final bool caseSensitive = false,
}) {
  if (text.trim().isEmpty || words.isEmpty) {
    return <WordMarker>[];
  }

  late final String textCased;
  late final Iterable<String> wordsCased;

  if (caseSensitive) {
    textCased = text;
    wordsCased = words;
  } else {
    textCased = text.toLowerCase();
    wordsCased = words.map((final String w) => w.toLowerCase());
  }

  List<WordMarker> rawMarkers = <WordMarker>[];

  for (final String word in wordsCased) {
    assert(word.isNotEmpty, 'word may not be an empty string');

    final Iterable<Match> wordMatches = word.allMatches(textCased);

    for (Match match in wordMatches) {
      rawMarkers.add(WordMarker(type: MarkerType.start, index: match.start));
      // IMPORTANT! end index is 1 character right of the actual word end
      rawMarkers.add(WordMarker(type: MarkerType.end, index: match.end));
    }
  }

  return rawMarkers;
}

/// Revises the given [rawMarkers], merges overlapping or embedded words
/// to one big "block" and returns a list of [WordMarker]s which represents
/// such "clean" word blocks.<br/>
/// Sorts the given [rawMarkers] by their index from lowest to highest.
List<WordMarker> getBlockMarkers(final List<WordMarker> rawMarkers) {
  final List<WordMarker> revisedMarkers = <WordMarker>[];

  // Sort raw markers by index, ascending.
  // Combine neighboring or overlapping blocks to one large block.
  rawMarkers.sort(sortByIndex);

  /// Counts the number of open blocks.
  /// When a start marker changes this value from 0 to 1, a new block starts.
  /// When an  end marker changes this value from 1 to 0, a block ends.
  /// All other constellations are ignored,
  /// as they mean overlapping or embedded blocks.
  int openCount = 0;
  for (WordMarker rawMarker in rawMarkers) {
    openCount += rawMarker.type == MarkerType.start ? 1 : -1;

    if (openCount < 0) {
      throw Exception('There cannot be less than 0 open blocks');
    }

    // value changes from 0 to 1 by start marker
    if (openCount == 1 && rawMarker.type == MarkerType.start) {
      revisedMarkers.add(rawMarker);
    }

    // value changes from 1 to 0 by end marker
    if (openCount == 0 && rawMarker.type == MarkerType.end) {
      revisedMarkers.add(rawMarker);
    }
  }

  return revisedMarkers;
}

/// Adds [tags] to the given [text] to mark words/blocks
/// enclosed by the given [markers].
/// The [tags] must be exactly 2 characters - one opening and one closing tag.
String getMarkedText({
  required final String text,
  required final Iterable<WordMarker> markers,
  final String tags = '[]',
}) {
  assert(
    tags.length == 2,
    'tags must be exactly 2 characters, one as opening and one as closing tag',
  );

  int runningIndex = 0;
  String markedText = '';
  final List<String> _tags = tags.split('');
  final String open = _tags[0];
  final String close = _tags[1];

  for (WordMarker marker in markers) {
    final String substring = text.substring(runningIndex, marker.index);

    markedText += substring + (marker.type == MarkerType.start ? open : close);

    runningIndex = marker.index;
  }
  markedText += text.substring(runningIndex);

  return markedText;
}

/// Returns a list of widgets representing texts parts, each with its own style.
/// Text enclosed by start and end markers, gets the given [wordStyle].
/// Text not enclosed by markers, gets the given [textStyle].
List<TextSpan> buildEmphasizedTextWidgets({
  required final String text,
  required Iterable<WordMarker> markers,
  required TextStyle textStyle,
  required TextStyle wordStyle,
}) {
  int runningIndex = 0;
  List<TextSpan> emphasizedTextWidgets = <TextSpan>[];

  for (WordMarker marker in markers) {
    final String substring = text.substring(runningIndex, marker.index);

    if (marker.type == MarkerType.start) {
      emphasizedTextWidgets.add(TextSpan(text: substring, style: textStyle));
    } else if (marker.type == MarkerType.end) {
      emphasizedTextWidgets.add(TextSpan(text: substring, style: wordStyle));
    }

    runningIndex = marker.index;
  }

  // add last part of text
  final String substring = text.substring(runningIndex, text.length);
  emphasizedTextWidgets.add(TextSpan(text: substring, style: textStyle));

  return emphasizedTextWidgets;
}
