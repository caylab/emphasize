import 'package:emphasize/word_marker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create with index 0 - creation successful', () {
    expect(WordMarker(type: MarkerType.start, index: 0), isA<WordMarker>());
  });

  test('create with index -1 - throws AssertionError', () {
    expect(() => WordMarker(type: MarkerType.start, index: -1), throwsAssertionError);
  });
  
  test('toString()', () {
    MarkerType type = MarkerType.start;
    const int index = 0;
    
    WordMarker marker = WordMarker(type: type, index: index);
    
    expect(marker.toString(), '$WordMarker(type: $type, index: $index)');
  });
}
