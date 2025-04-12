class Question {
  final String questionText;
  final List<String> answerOptions;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswerIndex,
  });

  String getQuestionText() => questionText;
  List<String> getAnswerOptions() => answerOptions;
  int getCorrectAnswerIndex() => correctAnswerIndex;
}