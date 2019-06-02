import 'package:flutter/material.dart';
import 'package:language_app/presentation/word_list.dart';

import 'presentation/add_word_screen.dart';

void main() => runApp(new LanguageApp());

class LanguageApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Language App",
        theme: new ThemeData(
            primarySwatch: Colors.blue
        ),
        home: new WordListScreen()
    );
  }
}