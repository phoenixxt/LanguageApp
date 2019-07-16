import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:language_app/data/entities/random_word.dart';
import 'package:language_app/domain/random_word_interactor.dart';
import 'package:language_app/presentation/inject_injereted_widget/app_inject_widget.dart';

import 'inject_injereted_widget/word_list_inject_widget.dart';

class WordListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WordListInjectWidget(
        child: WordListStatefulWidget(),
        appDependencyProvider: AppInjectWidget.of(context).getAppDependencyProvider());
  }
}

class WordListStatefulWidget extends StatefulWidget {
  @override
  State createState() {
    return _WordListState();
  }
}

class _WordListState extends State<WordListStatefulWidget> {
  RandomWordInteractor _randomWordInteractor;

  RandomWordList _randomWordList;

  @override
  Widget build(BuildContext context) {
    return PageView(children: _randomWordList.words.map(_createWordWidget).toList());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _randomWordInteractor = WordListInjectWidget.of(context)
        .getWordListDependencyProvider()
        .getRandomWordInteractor();
    _randomWordInteractor.getRandomWordsList().then((randomWordList) => {
          this.setState(() {
            _randomWordList = randomWordList;
          })
        });
  }

  Widget _createWordWidget(RandomWord randomWord) {
    return Center(child: Text(
        randomWord.randomWord,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold
      ),
    ));
  }
}
