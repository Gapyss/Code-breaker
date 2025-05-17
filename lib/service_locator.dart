import 'package:code_breaker_game/core/cipher_challenge.dart';
import 'package:code_breaker_game/core/cipher_generator.dart';
import 'package:code_breaker_game/presentation/code_breaker/code_breaker_view_model.dart';
import 'package:get_it/get_it.dart';

class ServiceLocator {
  final getIt = GetIt.instance;

  void setupDependencies() {
    getIt.registerLazySingleton(() => CipherGenerator());
    getIt.registerLazySingleton(
        () => CipherBloc(cipherGenerator: getIt<CipherGenerator>()));
    getIt.registerFactory(
        () => CodeBreakerViewModel(cipherBloc: getIt<CipherBloc>()));

  }
}
