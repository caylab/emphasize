library emphasize;

import 'package:flutter/material.dart';

import 'utils.dart';
import 'word_marker.dart';

/// Emphasizes [words] in a [text] by making them bold.
class Emphasize extends StatelessWidget {
  const Emphasize({
    required this.text,
    required this.words,
    this.caseSensitive = false,
    Key? key,
  }) : super(key: key);

  /// The text to emphasize words or word groups in.
  final String text;

  /// The words or word groups to emphasize in [text].
  final List<String> words;

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
        ),
      ),
    );
  }
}
