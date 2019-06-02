import 'package:language_app/data/api/api.dart';
import 'package:language_app/data/entities/random_word.dart';

class RandomWordInteractor {

  Api _api;

  RandomWordInteractor(this._api);

  Future<RandomWordList> getRandomWordsList() {
    return _api.getRandomWords(100).then((response) => RandomWordList.fromJsonLikeStringList(response.data));
  }
}