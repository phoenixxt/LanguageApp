import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/entities/random_word.dart';
import 'package:language_app/domain/bloc/list_bloc.dart';
import 'package:language_app/domain/bloc/list_state.dart';

class WordFlutterBlockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listBloc = BlocProvider.of<ListBloc>(context);
    return BlocBuilder(
      bloc: listBloc,
      // ignore: missing_return
      builder: (BuildContext context, ListState state) {
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is Failure) {
          return Center(
            child: Text('Oops something went wrong!'),
          );
        }
        if (state is Loaded) {
          if (state.words.isEmpty) {
            return Center(
              child: Text('no content'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return WordTile(
                randomWord: state.words[index],
                onDeletePressed: (word) {
                  //todo
                },
              );
            },
            itemCount: state.words.length,
          );
        }
      },
    );
  }
}

class WordTile extends StatelessWidget {
  final RandomWord randomWord;
  final Function(String) onDeletePressed;

  const WordTile({
    Key key,
    @required this.randomWord,
    @required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('#${randomWord.randomWord}'),
    );
  }
}
