
import 'package:flutter/material.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';
import 'package:vdenis/views/presentation/question/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final int finalScore;
  final int totalQuestions;

  const ResultScreen({super.key, required this.finalScore, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    final String scoreText = '$QuestionConstants.finalScoreQuestions$finalScore/$totalQuestions';
    final String feedbackMessage = finalScore > (totalQuestions / 2)
        ? '¡Buen trabajo!'
        : '¡Sigue practicando!';
    
    final Color buttonColor = finalScore > (totalQuestions / 2)
        ? Colors.blue
        : Colors.green;

    const TextStyle scoreTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldTitle(QuestionConstants.results),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              scoreText,
              style: scoreTextStyle,
            ),
            CommonWidgetsHelper.buildSpacing(height: 20),
            Text(
              feedbackMessage,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            CommonWidgetsHelper.buildSpacing(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: CommonWidgetsHelper.buildButtonStyle(QuestionConstants.playAgain),
            ),
          ],
        ),
      ),
    );
  }
 }