import 'package:dio/dio.dart';

/// Adds the API Ninjas key to every request.
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (apiKey.isNotEmpty) {
      options.headers['X-Api-Key'] = apiKey;
    }
    handler.next(options);
  }
}
