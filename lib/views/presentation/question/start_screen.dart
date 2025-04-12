import 'package:flutter/material.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/views/presentation/task/tasks_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleAppQuestions), backgroundColor: Colors.blue,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(welcomeMessage, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksScreen()),
                );
              },
              child: Text(startGame, style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}