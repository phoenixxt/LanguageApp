import 'package:flutter/material.dart';
import 'HomeScreen.dart';

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
        home: new HomeScreen()
    );
  }
}