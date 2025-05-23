import 'package:flutter/material.dart';
import 'package:vdenis/api/service/question_service.dart';
import 'package:vdenis/components/custom_bottom_navigation_bar.dart';
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
  final int _selectedIndex = 0;
  int? selectedAnswerIndex; // Índice de la respuesta seleccionada
  bool? isCorrectAnswer; // Estado para manejar si la respuesta es correcta


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
        userScore++; // Incrementa el puntaje si es correcto
      }
    });

    // Define el mensaje del SnackBar
    final snackBarMessage = isCorrectAnswer == true
        ? const SnackBar(
            content: Text('¡Correcto!'),
            backgroundColor: Colors.green,
          )
        : const SnackBar(
            content: Text('Incorrecto'),
            backgroundColor: Colors.red,
          );

    // Muestra el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);


    // Retraso para mostrar el color antes de avanzar
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return; // Verifica si el widget sigue montado

      // Oculta el SnackBar antes de avanzar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++; // Avanza a la siguiente pregunta
          selectedAnswerIndex = null; // Reinicia el índice seleccionado
          isCorrectAnswer = null; // Reinicia el estado de la respuesta
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
    if (questionsList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final questionCounterText =
        'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
    final currentQuestion = questionsList[currentQuestionIndex];
    const double spacingHeight = 16; // Variable para el espaciado entre la pregunta y las opciones
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Preguntas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,      
      body: 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¡Bienvenido al Juego!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Puntaje: $userScore',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  questionCounterText,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  currentQuestion.questionText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingHeight), // Espaciado entre la pregunta y las opciones
                ...currentQuestion.answerOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                   // Si la respuesta seleccionada es correcta, todos los botones serán verdes
                  final buttonColor = isCorrectAnswer == true
                      ? Colors.green
                      : (selectedAnswerIndex == index ? Colors.red : Colors.blue);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                       onPressed: selectedAnswerIndex == null
                      ? () => _onAnswerSelected(index)
                      : () {}, // Evita que el usuario seleccione otra opción
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Regresa a la pantalla anterior
                  },
                  child: const Text('Volver al Inicio'),
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar:  CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}