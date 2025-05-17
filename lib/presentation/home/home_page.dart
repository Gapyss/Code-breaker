import 'package:flutter/material.dart';

import '../code_breaker/code_breaker_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.8),
              theme.colorScheme.secondaryContainer.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Crack the Code',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Select Difficulty',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              ModernDifficultyButton(
                label: 'Easy',
                color: Colors.greenAccent.shade400,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CodeBreakerPage(arg: 'easy')),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ModernDifficultyButton(
                label: 'Medium',
                color: Colors.orangeAccent.shade400,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CodeBreakerPage(arg: 'medium')),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ModernDifficultyButton(
                label: 'Hard',
                color: Colors.redAccent.shade400,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CodeBreakerPage(arg: 'hard')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModernDifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ModernDifficultyButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
        textStyle:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        shadowColor: color.withOpacity(0.5),
      ),
      child: Text(label),
    );
  }
}
