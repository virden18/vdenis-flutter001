import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/noticia.dart';


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

    final DateTime today = DateTime.now();
    List<Noticia> newNoticias = List.generate(
      pageSize,
      (index) {
        return _noticiaRepository.generarNoticiaAleatoria();
      },
    );

    for (Noticia noticia in newNoticias) {
      if (noticia.titulo.isEmpty || noticia.descripcion.isEmpty || noticia.fuente.isEmpty) {
        throw ('titulo, descripcion, y fuente no pueden estar vacíos');
      }
      
      if (noticia.publicadaEl.isAfter(today)) {
        throw ('La fecha de publicación no puede ser una fecha futura.');
      } 
    }

    return newNoticias;
  }
}
