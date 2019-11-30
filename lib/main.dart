import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:language_app/dependencies/app_dependencies.dart';
import 'package:language_app/domain/bloc/list_bloc.dart';
import 'package:language_app/domain/bloc/simple_bloc_delegate.dart';
import 'package:language_app/presentation/camera_screen.dart';
import 'package:language_app/presentation/image_recognizer_screen.dart';
import 'package:language_app/presentation/word_list.dart';
import 'package:language_app/presentation/word_list_flutter_bloc.dart';

import 'domain/bloc/list_event.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  AppDependencies().configureDependencies();
  runApp(new LanguageApp());
}

class LanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Language App",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: Scaffold(
//              body: BlocProvider(
//                builder: (context) =>
//                ListBloc(GetIt.instance())..dispatch(Fetch()),
//                child: WordFlutterBlockPage(),
//              ),
              body: CameraApp(),
              backgroundColor: Colors.white,
            )
    );
  }
}
