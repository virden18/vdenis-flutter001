import 'package:flutter/material.dart';
import 'package:vdenis/api/service/question_service.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/domain/question.dart';
import 'package:vdenis/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  List<Question> questionsList = [];  
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedAnswerIndex;
  bool? isCorrectAnswer;


  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _questionService.getQuestions();
    setState(() {
      questionsList = questions;
    });
  }

  void _onAnswerSelected(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      isCorrectAnswer =
          questionsList[currentQuestionIndex].isCorrect(selectedIndex);

      if (isCorrectAnswer!) {
        userScore++;
      }
    });

    final snackBarMessage = isCorrectAnswer == true
        ? const SnackBar(
            content: Text('¡Correcto!'),
            backgroundColor: Colors.green,
          )
        : const SnackBar(
            content: Text('Incorrecto'),
            backgroundColor: Colors.red,
          );
    ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          isCorrectAnswer = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(finalScoreGame: userScore, totalQuestions: questionsList.length,),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (questionsList.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    final questionCounterText =
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
    final currentQuestion = questionsList[currentQuestionIndex];
    const double spacingHeight = 16; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Preguntas'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      drawer: const SideMenu(),
      backgroundColor: theme.scaffoldBackgroundColor,      
      body: 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '¡Bienvenido al Juego!',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Puntaje: $userScore',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  questionCounterText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  currentQuestion.questionText,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingHeight),
                ...currentQuestion.answerOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final buttonColor = selectedAnswerIndex == null
                      ? theme.colorScheme.primary
                      : (selectedAnswerIndex == index && isCorrectAnswer == true 
                          ? Colors.green 
                          : (selectedAnswerIndex == index ? Colors.red : theme.colorScheme.primary));

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: selectedAnswerIndex == null
                        ? () => _onAnswerSelected(index)
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        option,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),          
          ),
        ),
    );
  }
}