import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:language_app/dependency_providers/app_dependency_provider.dart';
import 'package:language_app/domain/bloc/list_bloc.dart';
import 'package:language_app/domain/bloc/simple_bloc_delegate.dart';
import 'package:language_app/presentation/word_list_flutter_bloc.dart';

import 'dependency_providers/word_list_dependency_provider.dart';
import 'domain/bloc/list_event.dart';
import 'presentation/inject_injereted_widget/app_inject_widget.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(new LanguageApp());
}

class LanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appDependencyProvider = AppDependencyProvider();
    var wordListDependencyProvider = WordListDependencyProvider(appDependencyProvider.getApi());
    return new AppInjectWidget(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Language App",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: Scaffold(
              body: BlocProvider(
                builder: (context) =>
                ListBloc(wordListDependencyProvider.getRandomWordInteractor())..dispatch(Fetch()),
                child: WordFlutterBlockPage(),
              ),
              backgroundColor: Colors.white,
            )));
  }
}
