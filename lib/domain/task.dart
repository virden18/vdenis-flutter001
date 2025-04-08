class Task {
  final String title;
  final String type;
  final String description;
  final DateTime date;

  Task({required this.title, this.type = 'normal', required this.description, required this.date});
}