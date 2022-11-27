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
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
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

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text (rtl, ltr).
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  final double textScaleFactor;

  /// The maximum number of lines the text may have.
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

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
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
