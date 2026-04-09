import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_breaker_game/core/cipher_generator.dart';
import 'package:get_it/get_it.dart';

import '../../core/cipher_challenge.dart';

// ── Game State ────────────────────────────────────────────────────────────────

class GameState {
  final CipherChallenge? challenge;
  final int score;
  final int streak;
  final String difficulty;
  final bool? lastAnswerCorrect;
  final int lastPointsEarned;

  const GameState({
    this.challenge,
    this.score = 0,
    this.streak = 0,
    this.difficulty = 'easy',
    this.lastAnswerCorrect,
    this.lastPointsEarned = 0,
  });

  GameState copyWith({
    CipherChallenge? challenge,
    int? score,
    int? streak,
    String? difficulty,
    bool? lastAnswerCorrect,
    int? lastPointsEarned,
    bool clearLastAnswer = false,
  }) {
    return GameState(
      challenge: challenge ?? this.challenge,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      difficulty: difficulty ?? this.difficulty,
      lastAnswerCorrect:
          clearLastAnswer ? null : (lastAnswerCorrect ?? this.lastAnswerCorrect),
      lastPointsEarned: lastPointsEarned ?? this.lastPointsEarned,
    );
  }
}

// ── Answer Result (passed to UI via stream) ───────────────────────────────────

class AnswerResult {
  final bool isCorrect;
  final int pointsEarned;
  final int streak;
  final int totalScore;

  AnswerResult({
    required this.isCorrect,
    required this.pointsEarned,
    required this.streak,
    required this.totalScore,
  });
}

// ── Events ────────────────────────────────────────────────────────────────────

abstract class CodeBreakerEvents {}

final class GetChallenge extends CodeBreakerEvents {
  final String mode;
  GetChallenge(this.mode);
}

final class SubmitAnswer extends CodeBreakerEvents {
  final String answer;
  SubmitAnswer(this.answer);
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class CipherBloc extends Bloc<CodeBreakerEvents, GameState> {
  final CipherGenerator _cipherGenerator;

  CipherBloc({required CipherGenerator cipherGenerator})
      : _cipherGenerator = cipherGenerator,
        super(const GameState()) {
    on<GetChallenge>(_onGetChallenge);
    on<SubmitAnswer>(_onSubmitAnswer);
  }

  Future<void> _onGetChallenge(
      GetChallenge event, Emitter<GameState> emit) async {
    final challenge = await _cipherGenerator.generateChallenge(event.mode);
    emit(state.copyWith(
      challenge: challenge,
      difficulty: event.mode,
      clearLastAnswer: true,
    ));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<GameState> emit) {
    final challenge = state.challenge;
    if (challenge == null) return;

    final isCorrect =
        event.answer.toUpperCase() == challenge.correctAnswer.toUpperCase();

    if (isCorrect) {
      final newStreak = state.streak + 1;
      final points = _pointsForDifficulty(state.difficulty) * newStreak;
      emit(state.copyWith(
        score: state.score + points,
        streak: newStreak,
        lastAnswerCorrect: true,
        lastPointsEarned: points,
      ));
    } else {
      emit(state.copyWith(
        streak: 0,
        lastAnswerCorrect: false,
        lastPointsEarned: 0,
      ));
    }
  }

  int _pointsForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'hard':
        return 30;
      case 'medium':
        return 20;
      default:
        return 10;
    }
  }
}

// ── ViewModel ─────────────────────────────────────────────────────────────────

class CodeBreakerViewModel {
  final CipherBloc cipherBloc;

  final _puzzleEncryptedController = StreamController<String>();
  final _exampleDecryptedController = StreamController<String>();
  final _exampleEncryptedController = StreamController<String>();
  final _correctAnswerController = StreamController<String>();
  final _scoreController = StreamController<int>();
  final _streakController = StreamController<int>();
  final _answerResultController = StreamController<AnswerResult>();

  StreamSubscription? _cipherSubscription;

  Stream<String> get puzzleEncrypted => _puzzleEncryptedController.stream;
  Stream<String> get exampleDecrypted => _exampleDecryptedController.stream;
  Stream<String> get exampleEncrypted => _exampleEncryptedController.stream;
  Stream<String> get correctAnswer => _correctAnswerController.stream;
  Stream<int> get score => _scoreController.stream;
  Stream<int> get streak => _streakController.stream;
  Stream<AnswerResult> get answerResult => _answerResultController.stream;

  String get currentCorrectAnswer =>
      cipherBloc.state.challenge?.correctAnswer ?? '';

  CodeBreakerViewModel({required this.cipherBloc}) {
    _cipherSubscription = cipherBloc.stream.listen((state) {
      final challenge = state.challenge;
      if (challenge != null) {
        _exampleDecryptedController.add(challenge.exampleDecrypted);
        _exampleEncryptedController.add(challenge.exampleEncrypted);
        _puzzleEncryptedController.add(challenge.puzzleEncrypted);
        _correctAnswerController.add(challenge.correctAnswer);
      }

      _scoreController.add(state.score);
      _streakController.add(state.streak);

      if (state.lastAnswerCorrect != null) {
        _answerResultController.add(AnswerResult(
          isCorrect: state.lastAnswerCorrect!,
          pointsEarned: state.lastPointsEarned,
          streak: state.streak,
          totalScore: state.score,
        ));
      }
    });
  }

  void onPageLoad(String mode) {
    cipherBloc.add(GetChallenge(mode));
  }

  void submitAnswer(String answer) {
    cipherBloc.add(SubmitAnswer(answer));
  }

  void dispose() {
    _puzzleEncryptedController.close();
    _exampleDecryptedController.close();
    _exampleEncryptedController.close();
    _correctAnswerController.close();
    _scoreController.close();
    _streakController.close();
    _answerResultController.close();
    _cipherSubscription?.cancel();
  }
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
