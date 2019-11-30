import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:language_app/data/api/DioProvider.dart';
import 'package:language_app/data/api/api.dart';
import 'package:language_app/domain/random_word_interactor.dart';

class AppDependencies {

  configureDependencies() {
    _apiDependency();

    final sl = GetIt.instance;
    sl.registerFactory(() => RandomWordInteractor(sl()));
  }

  _apiDependency() {
    final sl = GetIt.instance;
    sl.registerSingleton(DioProvider().dioClient());
    sl.registerFactory(() => Api(sl()));
  }
}