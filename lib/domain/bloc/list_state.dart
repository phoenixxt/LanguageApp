import 'package:equatable/equatable.dart';
import 'package:language_app/data/entities/random_word.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListState extends Equatable {
  ListState([List props = const []]) : super(props);
}

class Loading extends ListState {
  @override
  String toString() => 'Loading';
}

class Loaded extends ListState {
  final List<RandomWord> words;

  Loaded({@required this.words}) : super([words]);

  @override
  String toString() => 'Loaded { words: ${words.length} }';
}

class Failure extends ListState {
  @override
  String toString() => 'Failure';
}
