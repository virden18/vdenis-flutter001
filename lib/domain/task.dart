class Task {
  final String title;
  final String type;
  final String? description;
  final DateTime? date;
  final DateTime? fechaLimite; // Nueva fecha límite
  final List<String>? pasos; // Nuevos pasos

  Task({
    required this.title,
    this.type = 'normal', // Valor por defecto
    this.description,
    this.date,
    this.fechaLimite,
    this.pasos,
  });
}