import 'package:flutter/material.dart';

class AlphabetBottomSheet extends StatelessWidget {
  final Function(List<String?> list) onLetterSave;
  final List<String?> listAlphabet;

  const AlphabetBottomSheet(
      {super.key, required this.onLetterSave, required this.listAlphabet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Text(
              'Compare Alphabet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(26, (index) {
                  print(listAlphabet[index]);
                  final TextEditingController controller$index =
                      TextEditingController(text: listAlphabet[index]);
                  return Container(
                    color: theme.primaryColor,
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: controller$index,
                      maxLength: 1,
                      onSubmitted: (text) {
                        listAlphabet[index] = text;
                      },
                      decoration: const InputDecoration(counterText: ""),
                      showCursor: false,
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(26, (index) {
                  final letter = String.fromCharCode(65 + index);
                  return Container(
                    color: theme.primaryColor,
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        letter,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                onLetterSave.call(listAlphabet);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text("Save", style: TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ),
    );
  }
}
