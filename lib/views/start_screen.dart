import 'package:flutter/material.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/views/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(PreguntasConstantes.titleApp), 
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      drawer: const SideMenu(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              PreguntasConstantes.welcomeMessage, 
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                PreguntasConstantes.startGame,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}