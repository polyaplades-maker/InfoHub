import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_key_interceptor.dart';

class DioClient {
  DioClient(String apiKey) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.api-ninjas.com/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(ApiKeyInterceptor(apiKey));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 100,
      ),
    );
  }

  late final Dio dio;
}
