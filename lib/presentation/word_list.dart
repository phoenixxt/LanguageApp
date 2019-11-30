import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:language_app/data/entities/random_word.dart';
import 'package:language_app/domain/random_word_interactor.dart';

class WordListScreen extends StatelessWidget {
  final RandomWordInteractor _randomWordInteractor;

  WordListScreen(this._randomWordInteractor);

  @override
  Widget build(BuildContext context) {
    return WordListStatefulWidget(_randomWordInteractor);
  }
}

class WordListStatefulWidget extends StatefulWidget {
  final RandomWordInteractor _randomWordInteractor;

  WordListStatefulWidget(this._randomWordInteractor);

  @override
  State createState() {
    return _WordListState(_randomWordInteractor);
  }
}

class _WordListState extends State<WordListStatefulWidget> {
  RandomWordInteractor _randomWordInteractor;

  RandomWordList _randomWordList;

  _WordListState(this._randomWordInteractor);

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.95);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: 150,
            width: 400,
            color: Colors.greenAccent,
            child: Center(
                child: Text("KNOW THIS WORD",
                    style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center)),
          ),
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
        ),
        Positioned(
          child: Container(
            height: 150,
            width: 400,
            color: Colors.red,
            child: Center(
                child: Text(
              "DON'T KNOW THIS WORD",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            )),
          ),
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - 150,
          left: 0,
          right: 0,
        ),
        PageView.builder(
            itemCount: _randomWordList.words.length,
            controller: _pageController,
            itemBuilder: (context, index) => _createWordWidget(_randomWordList.words[index])),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _randomWordInteractor.getRandomWordsList().then((randomWordList) => {
          this.setState(() {
            _randomWordList = randomWordList;
          })
        });
  }

  Widget _createWordWidget(RandomWord randomWord) {
    return VerticallySwipableCard(Text(randomWord.randomWord, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)));
  }
}

class VerticallySwipableCard extends StatefulWidget {
  final Widget _childWidget;

  VerticallySwipableCard(this._childWidget);

  @override
  State createState() {
    return _VerticallySwipableCardState(_childWidget);
  }
}

class _VerticallySwipableCardState extends State<VerticallySwipableCard> {
  final Widget _childWidget;

  var _yDisplacement = 0.0;
  var _color = Colors.white;

  _VerticallySwipableCardState(this._childWidget);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 10,
                  child: AnimatedContainer(
                    height: 400,
                    width: 400,
                    color: _color,
                    child: Center(child: _childWidget),
                    duration: Duration(milliseconds: 200),
                  ),
                )),
            top: _yDisplacement + _centerPosition(context, 400),
            right: 0,
            left: 0,
            duration: Duration(milliseconds: _yDisplacement == 0 ? 200 : 0),
          ),
        ],
      ),
      onVerticalDragUpdate: (details) => {
        this.setState(() {
          if (_yDisplacement > 50) {
            _color = Colors.red;
          } else if (_yDisplacement < -50) {
            _color = Colors.greenAccent;
          } else {
            _color = Colors.white;
          }

          _yDisplacement += details.delta.dy;
        })
      },
      onVerticalDragEnd: (details) {
        this.setState(() {
          _color = Colors.white;
          _yDisplacement = 0;
        });
      },
    );
  }

  double _centerPosition(BuildContext context, int widgetHeight) {
    final queryData = MediaQuery.of(context);
    return (queryData.size.height - widgetHeight) / 2;
  }
}
