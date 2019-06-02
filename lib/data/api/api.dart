import 'package:dio/dio.dart';

class Api {
  static const RANDOM_WORD_LINK = "https://random-word-api.herokuapp.com/word?key=A8SSF4EJ&number=";

  Dio _dio;

  Api(this._dio);

  Future<Response> getRandomWords([int amountOfWordsToRequest = 100]) {
    return _dio.get("$RANDOM_WORD_LINK$amountOfWordsToRequest");
  }
}