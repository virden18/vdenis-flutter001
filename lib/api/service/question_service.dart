import 'package:vdenis/data/question_repository.dart';
import 'package:vdenis/domain/question.dart';

class QuestionService {
  final QuestionRepository _questionRepository = QuestionRepository();

  Future<List<Question>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _questionRepository.getInitialQuestions();
  }
}