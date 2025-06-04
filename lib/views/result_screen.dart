import 'package:flutter/material.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/views/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScoreGame;
  final int totalQuestions;

  const ResultScreen({super.key, required this.finalScoreGame, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double spacingHeight = 16;
    final String scoreText = 'Puntuación final: $finalScoreGame/$totalQuestions';
    final String feedbackMessage = finalScoreGame > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Juego Terminado!',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                scoreText,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacingHeight),
              Text(
                feedbackMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  PreguntasConstantes.playAgain,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}