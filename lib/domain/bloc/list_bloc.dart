import 'dart:async';
import 'package:bloc/bloc.dart';

import '../random_word_interactor.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final RandomWordInteractor _randomWordInteractor;

  ListBloc(this._randomWordInteractor);

  @override
  ListState get initialState => Loading();

  @override
  Stream<ListState> mapEventToState(
    ListEvent event,
  ) async* {
    if (event is Fetch) {
      try {
        final randomWordsList = await _randomWordInteractor.getRandomWordsList();
        yield Loaded(words: randomWordsList.words);
      } catch (_) {
        yield Failure();
      }
    }
  }
}
