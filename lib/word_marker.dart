enum MarkerType { start, end }

/// Marks a left ([MarkerType.start]) or right ([MarkerType.end]) boundary
/// of a word within a text.<br/>
/// IMPORTANT! The end index must be 1 character right of the actual word end,
/// as long as it is not the very end of the string.
class WordMarker {
  WordMarker({required this.type, required this.index}) : assert(index >= 0);

  final MarkerType type;
  final int index;

  @override
  String toString() {
    return '$WordMarker(type: $type, index: $index)';
  }
}
