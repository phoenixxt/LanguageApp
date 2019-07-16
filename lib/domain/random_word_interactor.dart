import 'dart:async';

import 'package:language_app/data/api/api.dart';
import 'package:language_app/data/entities/random_word.dart';

class RandomWordInteractor {

  Api _api;

  RandomWordInteractor(this._api);

  Future<RandomWordList> getRandomWordsList() {
    return _api.getRandomWords(100).then((response) => RandomWordList.fromJsonLikeStringList(response.data));
  }
}

class RandomWordBloc {

  final Api _api;

  final _randomWordListStreamController = StreamController<RandomWordList>();

  RandomWordBloc(this._api);

  Stream<RandomWordList> get randomWordListStream => _randomWordListStreamController.stream;

  dispose() {
    _randomWordListStreamController.sink.close();
    _randomWordListStreamController.close();
  }
}