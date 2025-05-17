class CipherChallenge {
  final String method;
  final String exampleEncrypted;
  final String exampleDecrypted;
  final String puzzleEncrypted;
  final String correctAnswer;
  final String? key;
  final int? shift;

  CipherChallenge({
    required this.method,
    required this.exampleEncrypted,
    required this.exampleDecrypted,
    required this.puzzleEncrypted,
    required this.correctAnswer,
    this.key,
    this.shift,
  });

  List<String> getHints() {
    List<String> hints = ["ประเภทการเข้ารหัส: $method"];
    if (method == "Caesar") {
      hints.add("การเลื่อนตัวอักษรคือ: +$shift");
      hints.add("ตัวแรกของคำตอบคือ: ${correctAnswer[0]}");
    } else if (method == "Vigenère") {
      hints.add("Key ที่ใช้คือ: $key");
      hints.add("ตัวแรกของคำตอบคือ: ${correctAnswer[0]}");
    } else if (method == "Base64") {
      hints.add("นี่คือการเข้ารหัสแบบ Base64");
    }
    return hints;
  }
}
