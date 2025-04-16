import 'package:vdenis/domain/noticia.dart';

class NoticiaRepository {
  final List<Noticia> noticias;

  NoticiaRepository() : noticias = [] {
    noticias.addAll([
      Noticia (
        titulo: 'Noticia 1',
        descripcion: 'Descripción de la noticia 1',
        fuente: 'Fuente 1',
        publicadaEl: DateTime(2025, 04, 07),
        ),
      Noticia(
        titulo: 'Noticia 2',
        descripcion: 'Descripción de la noticia 2',
        fuente: 'Fuente 2',
        publicadaEl: DateTime(2025, 04, 06),
      ),
      Noticia(
        titulo: 'Noticia 3',
        descripcion: 'Descripción de la noticia 3',
        fuente: 'Fuente 3',
        publicadaEl: DateTime(2025, 04, 05),
      ),
      Noticia(
        titulo: 'Noticia 4',
        descripcion: 'Descripción de la noticia 4',
        fuente: 'Fuente 4',
        publicadaEl: DateTime(2025, 04, 04),
      ),
      Noticia(
        titulo: 'Noticia 5',
        descripcion: 'Descripción de la noticia 5',
        fuente: 'Fuente 5',
        publicadaEl: DateTime(2025, 04, 03),
      ),
      Noticia(
        titulo: 'Noticia 6',
        descripcion: 'Descripción de la noticia 6',
        fuente: 'Fuente 6',
        publicadaEl: DateTime(2025, 04, 02),
      ),
      Noticia(
        titulo: 'Noticia 7',
        descripcion: 'Descripción de la noticia 7',
        fuente: 'Fuente 7',
        publicadaEl: DateTime(2025, 04, 01),
      ),
      Noticia(
        titulo: 'Noticia 8',
        descripcion: 'Descripción de la noticia 8',
        fuente: 'Fuente 8',
        publicadaEl: DateTime(2025, 03, 31),
      ),
      Noticia(
        titulo: 'Noticia 9',
        descripcion: 'Descripción de la noticia 9',
        fuente: 'Fuente 9',
        publicadaEl: DateTime(2025, 03, 30),
      ),
      Noticia(
        titulo: 'Noticia 10',
        descripcion: 'Descripción de la noticia 10',
        fuente: 'Fuente 10',
        publicadaEl: DateTime(2025, 03, 29),
      ),
      Noticia(
        titulo: 'Noticia 11',
        descripcion: 'Descripción de la noticia 11',
        fuente: 'Fuente 11',
        publicadaEl: DateTime(2025, 03, 28),
      ),
      Noticia(
        titulo: 'Noticia 12',
        descripcion: 'Descripción de la noticia 12',
        fuente: 'Fuente 12',
        publicadaEl: DateTime(2025, 03, 27),
      ),
      Noticia(
        titulo: 'Noticia 13',
        descripcion: 'Descripción de la noticia 13',
        fuente: 'Fuente 13',
        publicadaEl: DateTime(2025, 03, 26),
      ),
      Noticia(
        titulo: 'Noticia 14',
        descripcion: 'Descripción de la noticia 14',
        fuente: 'Fuente 14',
        publicadaEl: DateTime(2025, 03, 25),
      ),
      Noticia(
        titulo: 'Noticia 15',
        descripcion: 'Descripción de la noticia 15',
        fuente: 'Fuente 15',
        publicadaEl: DateTime(2025, 03, 24),
      ),
    ]);
  }
}
