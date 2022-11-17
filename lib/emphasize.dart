library emphasize;

import 'package:flutter/material.dart';

import 'utils.dart';
import 'word_marker.dart';

/// Emphasizes [words] in a [text] by making them bold.
class Emphasize extends StatelessWidget {
  Emphasize({
    required this.text,
    required this.words,
    TextStyle? textStyle,
    TextStyle? wordStyle,
    this.caseSensitive = false,
    Key? key,
  }) : super(key: key) {
    this.textStyle = textStyle ??
        const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        );

    this.wordStyle = wordStyle ??
        this.textStyle.copyWith(
              fontWeight: FontWeight.bold,
            );
  }

  /// The text to emphasize words or word groups in.
  final String text;

  /// The words or word groups to highlight in [text].
  final Iterable<String> words;

  /// Style for the non-highlighted parts of [text].
  late final TextStyle textStyle;

  /// Style for items in [words].
  late final TextStyle wordStyle;

  /// If `true`, [words] are matched in [text] case-sensitively.
  /// Otherwise, [words] are matched in [text] case-insensitively.
  final bool caseSensitive;

  @override
  Widget build(BuildContext context) {
    List<WordMarker> rawMarkers = getRawMarkers(
      text: text,
      words: words,
      caseSensitive: caseSensitive,
    );

    return RichText(
      text: TextSpan(
        children: buildEmphasizedTextWidgets(
          text: text,
          markers: getBlockMarkers(rawMarkers),
          textStyle: textStyle,
          wordStyle: wordStyle,
        ),
      ),
    );
  }
}
