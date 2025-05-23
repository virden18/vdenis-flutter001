import 'package:vdenis/data/question_repository.dart';
import 'package:vdenis/domain/question.dart';

class QuestionService {
  final QuestionRepository _questionRepository = QuestionRepository();

  // Método para obtener las preguntas desde el repositorio
  Future<List<Question>> getQuestions() async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las preguntas iniciales del repositorio
    return _questionRepository.getInitialQuestions();
  }
}