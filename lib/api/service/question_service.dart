import 'package:vdenis/data/question_respository.dart';
import 'package:vdenis/domain/question.dart';

class QuestionService {
  final QuestionRepository _repository = QuestionRepository();

  List<Question> getQuestions() {
    return _repository.getQuestions();
  }
}