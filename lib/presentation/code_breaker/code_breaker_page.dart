import 'package:code_breaker_game/presentation/code_breaker/code_breaker_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/cipher_generator.dart';
import '../widget/alphabet_buttom_sheet.dart';

class CodeBreakerPage extends StatefulWidget {
  const CodeBreakerPage({super.key});

  @override
  State<CodeBreakerPage> createState() => _CodeBreakerPageState();
}

class _CodeBreakerPageState extends State<CodeBreakerPage> {
  String userAnswer = "";
  String message = "";
  String _puzzleEncrypted = "";
  String _correctAnswer = "";
  final answerController = TextEditingController();
  final focusNode = FocusNode();
  int hintLevel = 1; // Start with hint level 1
  final viewModel = GetIt.I.get<CodeBreakerViewModel>();

  void viewModelListener() {
    viewModel.puzzleEncrypted.listen((puzzleEncrypt) {
      setState(() {
        _puzzleEncrypted = puzzleEncrypt;
      });
    });

    viewModel.correctAnswer.listen((correctAnswer) {
      setState(() {
        _correctAnswer = correctAnswer;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    viewModel.onPageLoad();
    viewModelListener();
  }

  void checkAnswer() {
    if (userAnswer.toUpperCase() ==
        viewModel.currentCorrectAnswer.toUpperCase()) {
      showCorrectAnswerDialog(context, () {
        viewModel.onPageLoad();
        Navigator.of(context).pop();
        focusNode.unfocus();
        answerController.clear();
      });
    } else {
      showWrongAnswerDialog(context, () {
        Navigator.of(context).pop();
        focusNode.unfocus();
        answerController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Code Breaker Game"),
        centerTitle: true,
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          showAlphabetPicker(context, (val) {
            setState(() {
              // userAnswer += val;
            });
          });
        },
        icon: const Icon(Icons.abc),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20.0),
            _buildUnderstandingCipher(theme),
            const SizedBox(height: 24.0),
            CrackTheCode(
              puzzleEncrypted: _puzzleEncrypted,
              correctAnswer: _correctAnswer,
            ),
            const SizedBox(height: 24.0),
            _buildUserInput(theme),
            const SizedBox(height: 24.0),
            _buildSubmitButton(),
            const SizedBox(height: 24.0),
            Text(
              message,
              style:
                  TextStyle(fontSize: 18.0, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderstandingCipher(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: theme.colorScheme.outline.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 8,
          ),
        ],
      ),
      child: StreamBuilder<String>(
        stream: viewModel.exampleEncrypted,
        builder: (context, exampleEncryptedSnapshot) {
          final encryptedText = exampleEncryptedSnapshot.data ?? "";
          return StreamBuilder<String>(
            stream: viewModel.exampleDecrypted,
            builder: (context, exampleDecryptedSnapshot) {
              final decryptedText = exampleDecryptedSnapshot.data ?? "";
              return Text(
                "Understanding the Cipher: $encryptedText → $decryptedText",
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: answerController,
        focusNode: focusNode,
        maxLength: 10,
        onChanged: (val) => userAnswer = val,
        decoration: InputDecoration(
          labelText: "Enter Your Decoded Word Here",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: checkAnswer,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: const Text("Submit Guess", style: TextStyle(fontSize: 18.0)),
    );
  }

  void showCorrectAnswerDialog(
      BuildContext context, VoidCallback onNextPuzzle) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Column(
            children: [
              Icon(Icons.check_circle_outline,
                  size: 60.0, color: Colors.green.shade400),
              // Larger success icon
              const SizedBox(height: 12.0),
              Text(
                "Code Cracked!", // More impactful title
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Congratulations! You've successfully decoded the word.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: onNextPuzzle, // Use the provided callback
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: Colors.green.shade400, // Success color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                  ),
                  child: const Text("Next Puzzle",
                      style: TextStyle(fontSize: 18.0)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showWrongAnswerDialog(BuildContext context, VoidCallback onTryAgain) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow closing by tapping outside
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Column(
            children: [
              const Icon(Icons.error_outline,
                  size: 60.0, color: Colors.redAccent),
              // Larger error icon
              const SizedBox(height: 12.0),
              Text(
                "Not Quite!", // More encouraging title
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "That's not the correct code. Keep trying, you're getting closer!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: onTryAgain, // Use the provided callback
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: Colors.redAccent, // Error color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                  ),
                  child:
                      const Text("Try Again", style: TextStyle(fontSize: 18.0)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void showAlphabetPicker(
    BuildContext context, Function(String) onLetterSelected) {
  List<String?> tempList = List.generate(26, (i) => "");
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AlphabetBottomSheet(
        onLetterSave: (listAlphabet) {
          tempList = listAlphabet;
        },
        listAlphabet: tempList,
        // on: onLetterSelected, // Pass the callback here
      );
    },
  );
}

class CrackTheCode extends StatelessWidget {
  final String puzzleEncrypted;
  final String correctAnswer;

  const CrackTheCode({
    super.key,
    required this.puzzleEncrypted,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              color: theme.colorScheme.outline.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 8),
        ],
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Crack the Code: ", style: theme.textTheme.headlineMedium),
          Text(
            puzzleEncrypted,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12.0),
          Text(
            _getHintText(correctAnswer),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getHintText(String correct) {
    final correctAnswer = correct;
    if (correctAnswer.isNotEmpty) {
      final hint = CipherGenerator.getHint(correctAnswer, 1);
      return "Hint: $hint (length: ${correctAnswer.length})";
    }
    return "Hint: ";
  }
}
