import 'package:flutter/material.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/views/helpers/common_widgets_helper.dart';
import 'package:vdenis/views/presentation/question/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonWidgetsHelper.buildBoldAppBarTitle(titleAppQuestions), 
        centerTitle: true, 
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(welcomeMessage, style: TextStyle(fontSize: 20)),
            CommonWidgetsHelper.buildSpacing(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              child: CommonWidgetsHelper.buildButtonStyle(startGame),
            ),
          ],
        ),
      ),
    );
  }
}