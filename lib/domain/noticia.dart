import 'package:vdenis/constants/constants.dart';

class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String urlImagen;
  final String? categoriaId; // Nuevo campo para categoría

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    this.categoriaId, // Opcional, puede ser nulo
  });

  // Método para crear una instancia de Noticia desde un JSON
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fuente: json['fuente'] ?? '',
      publicadaEl: json['publicadaEl'] != null
          ? DateTime.parse(json['publicadaEl'])
          : DateTime.now(),
      urlImagen: json['urlImagen'] ?? '',
      categoriaId: json['categoriaId'] ?? Constants.defaultCategoriaId,
    );
  }

  // Método para convertir una instancia de Noticia a JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': urlImagen,
      'categoriaId': categoriaId ?? Constants.defaultCategoriaId,
    };
  }
}
