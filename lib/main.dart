import 'package:flutter/material.dart';
import 'package:language_app/presentation/word_list.dart';

import 'presentation/inject_injereted_widget/app_inject_widget.dart';

void main() => runApp(new LanguageApp());

class LanguageApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new AppInjectWidget(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Language App",
            theme: new ThemeData(
                primarySwatch: Colors.blue
            ),
            home: new WordListScreen()
        )
    );
  }
}