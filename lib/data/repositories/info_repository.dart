import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/exercise.dart';
import '../models/fact.dart';

class InfoRepository {
  InfoRepository(DioClient client) : _dio = client.dio;

  final Dio _dio;

  Future<Fact> getRandomFact() async {
    final response = await _dio.get('/facts');
    final data = response.data;
    if (data is List && data.isNotEmpty && data.first is Map) {
      return Fact.fromJson(Map<String, dynamic>.from(data.first as Map));
    }
    throw Exception('The API returned an empty fact.');
  }

  Future<List<Exercise>> getExercises({
    String? muscle,
    String? name,
    String? difficulty,
  }) async {
    final query = <String, dynamic>{};
    if (muscle != null && muscle.isNotEmpty) query['muscle'] = muscle;
    if (name != null && name.trim().isNotEmpty) query['name'] = name.trim();
    if (difficulty != null && difficulty.isNotEmpty) {
      query['difficulty'] = difficulty;
    }

    final response = await _dio.get('/exercises', queryParameters: query);
    final data = response.data;
    if (data is! List) {
      throw Exception('Unexpected response from the API.');
    }
    return data
        .whereType<Map>()
        .map((item) => Exercise.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
