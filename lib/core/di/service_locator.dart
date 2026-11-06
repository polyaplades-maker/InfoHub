import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../data/repositories/info_repository.dart';

final getIt = GetIt.instance;


const String apiNinjasApiKey = 'leCSahbhB0s1YAQW5lxhtNQy5cq1xtaM9SiLQljR';

void setupDependencies() {
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(apiNinjasApiKey),
  );
  getIt.registerLazySingleton<InfoRepository>(
    () => InfoRepository(getIt<DioClient>()),
  );
}
