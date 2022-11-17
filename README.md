Highlight text, words or word groups within a text, using custom styles.

This package has no issue with numbers or special characters in the text or highlighted words.
It can also easily handle overlapping words or words embedded within each other.


## Features

* highlight words or word groups in a text
* overlapping words are combined to one highlighted block
* can handle numbers and special characters embedded in the text or words
* standalone package - no dependencies (except Flutter)


## Getting started

To use this package, add `emphasize` as a [dependency in your pubspec.yaml file](https://docs.flutter.dev/development/packages-and-plugins/using-packages).


## Usage

```dart
Emphasize emphasizedText = Emphasize(
  text: 'The quick brown Fox jumps over the lazy Dog',
  words: ['brown fox', 'lazy dog'],
  caseSensitive: false,
);
```

The `Emphasize` object is a `StatelessWidget` which can be used like any other widget.


## Additional information

This package's repository can be found on GitHub:
https://github.com/caylab/emphasize

There you can file issues, request features and contribute to the project
if you feel like doing so. :)