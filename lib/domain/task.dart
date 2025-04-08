class Task {
  final String title;
  final String type;
  final String description;
  final DateTime date;
  final DateTime? fechaLimite;
  final List<String>? pasos;

  Task({required this.title, this.type = 'normal', required this.description, required this.date, this.fechaLimite, this.pasos = const []});
}