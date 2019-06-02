import 'package:flutter/material.dart';
import 'package:language_app/data/database/database.dart';
import 'package:language_app/data/entities/word.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _spanishTextController = TextEditingController();

  final _englishTextController = TextEditingController();

  final dbHelper = DBHelper();

  List<Word> _listOfWords = List();

  @override
  void initState() {
    super.initState();
    dbHelper.getWords().then((words) {
      setState(() {
        _listOfWords.addAll(words);
      });
    }, onError: (error) => { print(error) });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _createCenteredTextForm(50.0, "Spanish word", _spanishTextController),
        _createCenteredTextForm(
            10.0, "English translation", _englishTextController),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: FlatButton(
                onPressed: () => _onAddWordPressed(context),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Add word"),
                )),
          ),
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                  itemCount: _listOfWords.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _createWordRow(position);
                  }),
        ))
      ],
    ));
  }

  Align _createCenteredTextForm(
      double topMargin, String hintText, TextEditingController textController) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin, left: 10.0, right: 10.0),
        child: TextFormField(
          controller: textController,
          decoration: InputDecoration(labelText: hintText),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _spanishTextController.dispose();
    _englishTextController.dispose();
    super.dispose();
  }

  _onAddWordPressed(BuildContext context) {
    var spanishWord = _spanishTextController.text;
    var englishTranslation = _englishTextController.text;
    if (spanishWord.isNotEmpty && englishTranslation.isNotEmpty) {
      var word = Word(spanishWord, englishTranslation);
      dbHelper.saveWord(word);
      setState(() {
        _listOfWords.add(word);
      });
      _spanishTextController.clear();
      _englishTextController.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      _showDialogWithText(
          context, "You need to enter a word and its translation first");
    }
  }

  _showDialogWithText(BuildContext context, String textToShow) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text(
            textToShow,
            textAlign: TextAlign.center,
          ));
        });
  }

  Widget _createWordRow(int position) {
    return Row(
      children: <Widget>[
        _createPaddedText(10.0, _listOfWords[position].spanishWord, 15.0, true),
        _createPaddedText(15.0, _listOfWords[position].englishTranslation, 13.0)
      ],
    );
  }

  Widget _createPaddedText(double leftPadding, String text, double fontSize,
      [bool isBold = false]) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
