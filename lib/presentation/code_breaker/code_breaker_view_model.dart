import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_breaker_game/core/cipher_generator.dart';
import 'package:get_it/get_it.dart';

import '../../core/cipher_challenge.dart';

class CodeBreakerViewModel {
  final CipherBloc cipherBloc;

  final _puzzleEncryptedController = StreamController<String>();
  final _exampleDecryptedController = StreamController<String>();
  final _exampleEncryptedController = StreamController<String>();
  final _correctAnswerController = StreamController<String>();

  String? _currentCorrectAnswer;
  StreamSubscription? _cipherSubscription;

  Stream<String> get puzzleEncrypted => _puzzleEncryptedController.stream;

  Stream<String> get exampleDecrypted => _exampleDecryptedController.stream;

  Stream<String> get exampleEncrypted => _exampleEncryptedController.stream;

  Stream<String> get correctAnswer => _correctAnswerController.stream;

  String get currentCorrectAnswer => _currentCorrectAnswer ?? '';

  CodeBreakerViewModel({required this.cipherBloc}) {
    _cipherSubscription = cipherBloc.stream.listen((challenge) {
      if (challenge != null) {
        _currentCorrectAnswer = challenge.correctAnswer;
        _exampleDecryptedController.add(challenge.exampleDecrypted);
        _exampleEncryptedController.add(challenge.exampleEncrypted);
        _puzzleEncryptedController.add(challenge.puzzleEncrypted);
        _correctAnswerController.add(challenge.correctAnswer);
      }
    });
  }

  void onPageLoad(String mode) {
    cipherBloc.add(GetChallenge(mode));
  }

  void dispose() {
    _puzzleEncryptedController.close();
    _exampleDecryptedController.close();
    _exampleEncryptedController.close();
    _correctAnswerController.close();
    _cipherSubscription?.cancel(); // Cancel the subscription
  }
}

class CipherBloc extends Bloc<CodeBreakerEvents, CipherChallenge?> {
  final CipherGenerator _cipherGenerator;

  CipherBloc({required CipherGenerator cipherGenerator})
      : _cipherGenerator = cipherGenerator,
        super(null) {
    on<GetChallenge>((event, emit) async {
      final challenge = await _cipherGenerator.generateChallenge(event.mode);
      emit(challenge);
    });
  }
}

abstract class CodeBreakerEvents {}

final class GetChallenge extends CodeBreakerEvents {
  final String mode;

  GetChallenge(this.mode);
}

// In your service_locator.dart:
final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => CipherGenerator());
  getIt.registerLazySingleton(
      () => CipherBloc(cipherGenerator: getIt<CipherGenerator>()));
  getIt.registerFactory(
      () => CodeBreakerViewModel(cipherBloc: getIt<CipherBloc>()));
}
