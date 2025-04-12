import '../domain/question.dart';

class QuestionRepository {
  final List<Question> questions;

  QuestionRepository() : questions = [] {
    questions.addAll(
      [
        Question(
          questionText: '¿Cuál es la capital de Francia?',
          answerOptions: ['Madrid', 'París', 'Roma'],
          correctAnswerIndex: 1,
        ),
        Question(
          questionText: '¿Cuántos planetas hay en el sistema solar?',
          answerOptions: ['8', '9', '10'],
          correctAnswerIndex: 0,
        ),
        Question(
          questionText: '¿En qué año llegó el hombre a la luna?',
          answerOptions: ['1965', '1967', '1969'],
          correctAnswerIndex: 2,
        ),
        Question(
          questionText: '¿Qué planeta es conocido como el planeta rojo?', 
          answerOptions: ['Júpiter', 'Marte', 'Venus'],
          correctAnswerIndex: 1,
        ), 
      ]
    );
  }

  List<Question> getQuestions() {
    return questions;
  }
}