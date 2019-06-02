import 'package:dio/dio.dart';

class DioProvider {

  Dio _dio;
  
  Dio getDioClient() {
    if (_dio == null) {
      _dio = Dio();
    }
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options) {
        print("headers request ${options.headers}");
        print("request ${options.data}");
        return options;
      },
      onResponse: (options) {
        print("headers response ${options.headers}");
        print("response ${options.data}");
        return options;
      }
    ));
    return _dio;
  }
}