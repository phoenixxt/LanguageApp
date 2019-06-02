import 'package:flutter/widgets.dart';
import 'package:language_app/data/api/DioProvider.dart';
import 'package:language_app/data/api/api.dart';
import 'package:language_app/data/entities/random_word.dart';
import 'package:language_app/domain/random_word_interactor.dart';

class WordListScreen extends StatefulWidget {

  @override
  State createState() {
    return _WordListState();
  }
}

class _WordListState extends State<WordListScreen> {

  RandomWordInteractor _randomWordInteractor;

  RandomWordList _randomWordList;

  @override
  Widget build(BuildContext context) {
    return PageView(children: _randomWordList.words.map((randomWord) => Text(randomWord.randomWord)).toList());
  }

  @override
  void initState() {
    if (_randomWordInteractor == null) {
      _randomWordInteractor = RandomWordInteractor(Api(DioProvider().getDioClient()));
    }
    _randomWordInteractor.getRandomWordsList().then((randomWordList) => {
      this.setState(() {
        _randomWordList = randomWordList;
      })
    });
  }
}