class Task {
  final String title;
  final String type;
  final String description;
  final DateTime date;
  final DateTime fechaLimite;
  final List<String>? pasos;

  // Constructor
  Task({
    required this.title,
    this.type = 'normal',
    required this.description,
    required this.date,
    required this.fechaLimite,
    this.pasos = const [],
  });

  // Getters
  String get getTitle => title;
  String get getType => type;
  String get getDescription => description;
  DateTime get getDate => date;
  DateTime get getFechaLimite => fechaLimite;
  List<String>? get getPasos => pasos;

  String fechaLimiteToString() {
    return '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';
  }
}
