import 'package:vdenis/domain/question.dart';

class QuestionRepository {
  List<Question> getInitialQuestions() {
    return [
      Question(
        questionText: '¿Cuál es la capital de Francia?',
        answerOptions: ['Madrid', 'París', 'Roma'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: '¿Cuál es el lenguaje utilizado en Flutter?',
        answerOptions: ['Java', 'Dart', 'Python'],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: '¿Cuántos continentes hay en el mundo?',
        answerOptions: ['5', '6', '7'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: '¿Qué planeta es conocido como el planeta rojo?',
        answerOptions: ['Júpiter', 'Marte', 'Venus'],
        correctAnswerIndex: 1,
      ),
    ];
  }
}
