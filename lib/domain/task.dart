class Task {
  final String title;
  final String type;
  final String description;
  final DateTime deadLine;
  final DateTime fechaLimite;
  List<String>? pasos;

  // Constructor
  Task({
    required this.title,
    this.type = 'normal',
    required this.description,
    required this.deadLine,
    required this.fechaLimite,
    this.pasos = const [],
  });

  // Getters
  String get getTitle => title;
  String get getType => type;
  String get getDescription => description;
  DateTime get getDate => deadLine;
  DateTime get getFechaLimite => fechaLimite;
  List<String>? get getPasos => pasos;

  String fechaLimiteToString() {
    return '${fechaLimite.day}/${fechaLimite.month}/${fechaLimite.year}';
  }

  String fechaToString() {
    return '${deadLine.day}/${deadLine.month}/${deadLine.year}';
  }

  void setPasos(List<String> pasos) {
    if (this.pasos == null || this.pasos!.isEmpty) {
      this.pasos = pasos;
    }
  }
}
