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

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (options) async {
       if (options.data.toString() == "wrong API key") {
        var result = await _dio.get("https://random-word-api.herokuapp.com/key?");
        return await _dio.get("https://random-word-api.herokuapp.com/word?key=${result.data}&number=100");
       }
       return options;
      }
    ));
    return _dio;
  }
}