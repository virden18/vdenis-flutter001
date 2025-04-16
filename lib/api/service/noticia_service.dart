import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/noticia.dart';
import 'dart:math';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();

  List<Noticia> getNoticias() {
    return _noticiaRepository.noticias;
  }

  List<Noticia> loadMoreNoticias({required page, int pageSize = Constants.tamanoPaginaConst}) {
    // Validaciones
    if (page < 1) {
      throw ArgumentError('El número de página debe ser mayor o igual a 1.');
    }
    if (pageSize <= 0) {
      throw ArgumentError('El tamaño de página debe ser mayor a 0.');
    }

    final random = Random();

    List<Noticia> newTasks = List.generate(
      pageSize,
      (index) {
        final titulo = 'Noticia ${page + index}';
        final descripcion = 'Descripción de la noticia ${page + index}';
        final fuente = 'Fuente ${page + index}';

        // Validaciones para los campos
        if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
          throw ArgumentError('El título, descripción y fuente no pueden estar vacíos.');
        }

        // Generar una fecha aleatoria
        final dia = random.nextInt(30);
        final mes = random.nextInt(12);
        final anho = 2020 + random.nextInt(4);
        final hora = random.nextInt(24); 
        final minutos = random.nextInt(60);
        final segundos = random.nextInt(60); 

        return Noticia(
          titulo: titulo,
          descripcion: descripcion,
          fuente: fuente,
          publicadaEl: DateTime(
            anho,
            mes,
            dia,
            hora,
            minutos,
            segundos,
          ).add(Duration(days: -index)),
        );
      },
    );

    return newTasks;
  }
}
