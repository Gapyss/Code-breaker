import 'dart:math';
import 'package:flutter/services.dart';
import 'cipher_challenge.dart';

class CipherGenerator {
  static Future<List<String>> _loadWords() async {
    final String wordList = await rootBundle.loadString('asset/wording.txt');
    return wordList
        .split('\n')
        .map((word) => word.trim().toUpperCase())
        .toList();
  }

  static Map<String, List<String>> categorizeWords(List<String> words) {
    Map<String, List<String>> categorizedWords = {
      'easy': [],
      'medium': [],
      'hard': [],
    };
    for (var word in words) {
      if (word.length <= 3 && word.length > 1) {
        categorizedWords['easy']?.add(word);
      } else if (word.length <= 5) {
        categorizedWords['medium']?.add(word);
      } else {
        categorizedWords['hard']?.add(word);
      }
    }
    return categorizedWords;
  }

  static String caesarEncrypt(String input, int shift) {
    return String.fromCharCodes(input.toUpperCase().codeUnits.map((char) {
      if (char >= 65 && char <= 90) {
        return ((char - 65 + shift) % 26) + 65;
      }
      return char;
    }));
  }

  static CipherChallenge generateRandomChallenge(
      List<String> words, String difficulty) {
    // เลือกคำจากโหมดที่เลือก
    final filteredWords = words
        .where((word) =>
            word.length <= 3 && difficulty == 'easy' ||
            word.length > 3 && word.length <= 5 && difficulty == 'medium' ||
            word.length > 5 && difficulty == 'hard')
        .toList();

    final word1 = filteredWords[
        (DateTime.now().millisecondsSinceEpoch % filteredWords.length)];
    final word2 = filteredWords[
        (DateTime.now().millisecondsSinceEpoch + 1) % filteredWords.length];
    final shift = 1 + (DateTime.now().millisecond % 25); // shift 1–25

    return CipherChallenge(
      method: "caesar",
      exampleEncrypted: caesarEncrypt(word1, shift),
      exampleDecrypted: word1,
      puzzleEncrypted: caesarEncrypt(word2, shift),
      correctAnswer: word2,
    );
  }

  Future<CipherChallenge> generateChallenge() async {
    List<String> words = await _loadWords();

    return generateRandomChallenge(words, 'medium');
  }

  static String getHint(String text, int revealCount) {
    Random random = Random();
    List<int> revealedIndices = [];

    revealCount = revealCount > text.length ? text.length : revealCount;

    while (revealedIndices.length < revealCount) {
      int randomIndex = random.nextInt(text.length);
      if (!revealedIndices.contains(randomIndex)) {
        revealedIndices.add(randomIndex);
      }
    }

    List<String> result = List.generate(text.length, (index) {
      if (revealedIndices.contains(index)) {
        return text[index];
      } else {
        return '_';
      }
    });

    return result.join(' ');
  }
}
