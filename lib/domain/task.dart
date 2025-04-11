class Task {
  final String title;
  final String type;
  final String description;
  final DateTime date;
  final DateTime deadLine;
  List<String>? pasos;

  // Constructor
  Task({
    required this.title,
    this.type = 'normal',
    required this.description,
    required this.date,
    required this.deadLine,
    this.pasos = const [],
  });

  // Getters
  String get getTitle => title;
  String get getType => type;
  String get getDescription => description;
  DateTime get getDate => date;
  DateTime get getFechaLimite => deadLine;
  List<String>? get getPasos => pasos;

  String fechaLimiteToString() {
    return '${deadLine.day}/${deadLine.month}/${deadLine.year}';
  }

  String fechaToString() {
    return '${date.day}/${date.month}/${date.year}';
  }

  void setPasos(List<String> pasos) {
    if (this.pasos == null || this.pasos!.isEmpty) {
      this.pasos = pasos;
    }
  }
}
