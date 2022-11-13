import 'package:emphasize/emphasize.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emphasizedText = Emphasize(
      text: 'The quick brown Fox jumps over the lazy Dog',
      words: const <String>['brown fox', 'lazy dog'],
      caseSensitive: false,
    );

    return Scaffold(body: Center(child: emphasizedText));
  }
}
