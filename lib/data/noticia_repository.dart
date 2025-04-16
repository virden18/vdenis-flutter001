import 'dart:math';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaRepository {
  final List<Noticia> noticias;

  NoticiaRepository() : noticias = [] {
    noticias.addAll([
      Noticia(
        titulo: 'Descubrimiento Científico',
        descripcion: 'Científicos descubren una nueva partícula subatómica.',
        fuente: 'Ciencia Hoy',
        publicadaEl: DateTime(2025, 04, 07),
      ),
      Noticia(
        titulo: 'Avance Médico',
        descripcion: 'Un nuevo tratamiento promete curar enfermedades raras.',
        fuente: 'Salud Global',
        publicadaEl: DateTime(2025, 04, 06),
      ),
      Noticia(
        titulo: 'Tecnología Innovadora',
        descripcion: 'Se lanza un dispositivo que revoluciona la comunicación.',
        fuente: 'Tech News',
        publicadaEl: DateTime(2025, 04, 05),
      ),
      Noticia(
        titulo: 'Crisis Climática',
        descripcion: 'Expertos advierten sobre el aumento del nivel del mar.',
        fuente: 'Medio Ambiente',
        publicadaEl: DateTime(2025, 04, 04),
      ),
      Noticia(
        titulo: 'Evento Deportivo',
        descripcion: 'El equipo local gana el campeonato nacional.',
        fuente: 'Deportes Hoy',
        publicadaEl: DateTime(2025, 04, 03),
      ),
      Noticia(
        titulo: 'Arte y Cultura',
        descripcion: 'Una exposición de arte moderno atrae a miles de visitantes.',
        fuente: 'Cultura Viva',
        publicadaEl: DateTime(2025, 04, 02),
      ),
      Noticia(
        titulo: 'Economía Global',
        descripcion: 'Los mercados financieros experimentan una fuerte caída.',
        fuente: 'Economía Hoy',
        publicadaEl: DateTime(2025, 04, 01),
      ),
      Noticia(
        titulo: 'Exploración Espacial',
        descripcion: 'Una nueva misión espacial busca vida en Marte.',
        fuente: 'Espacio y Ciencia',
        publicadaEl: DateTime(2025, 03, 31),
      ),
      Noticia(
        titulo: 'Innovación en Energía',
        descripcion: 'Se desarrolla una batería que dura 10 años.',
        fuente: 'Energía Renovable',
        publicadaEl: DateTime(2025, 03, 30),
      ),
      Noticia(
        titulo: 'Educación',
        descripcion: 'Un nuevo método de enseñanza mejora el aprendizaje.',
        fuente: 'Educación Hoy',
        publicadaEl: DateTime(2025, 03, 29),
      ),
      Noticia(
        titulo: 'Moda y Estilo',
        descripcion: 'Una nueva tendencia de moda se vuelve viral.',
        fuente: 'Estilo Diario',
        publicadaEl: DateTime(2025, 03, 28),
      ),
      Noticia(
        titulo: 'Avance en Robótica',
        descripcion: 'Un robot realiza tareas complejas en tiempo récord.',
        fuente: 'Robótica Avanzada',
        publicadaEl: DateTime(2025, 03, 27),
      ),
      Noticia(
        titulo: 'Descubrimiento Arqueológico',
        descripcion: 'Se encuentra una ciudad perdida bajo el desierto.',
        fuente: 'Historia Viva',
        publicadaEl: DateTime(2025, 03, 26),
      ),
      Noticia(
        titulo: 'Música y Entretenimiento',
        descripcion: 'Un concierto reúne a miles de fanáticos.',
        fuente: 'Música Hoy',
        publicadaEl: DateTime(2025, 03, 25),
      ),
      Noticia(
        titulo: 'Avance en Inteligencia Artificial',
        descripcion: 'Un nuevo modelo de IA supera las expectativas.',
        fuente: 'Tech AI',
        publicadaEl: DateTime(2025, 03, 24),
      ),
    ]);
  }

  // Método para generar noticias aleatorias
  Noticia generarNoticiaAleatoria() {
    final random = Random();
    final titulo = Constants.titulosNoticias[random.nextInt(Constants.titulosNoticias.length)];
    final fuente = Constants.fuentesNoticias[random.nextInt(Constants.fuentesNoticias.length)];
    final descripcion = Constants.descripcionesNoticias[random.nextInt(Constants.descripcionesNoticias.length)];
    final publicadaEl = DateTime(
      2020 + random.nextInt(4), // año
      1 + random.nextInt(12), // mes
      1 + random.nextInt(28), // dia
      random.nextInt(24), // hora
      random.nextInt(60), // minuto
      random.nextInt(60), // segundo
    );

    return Noticia(
      titulo: titulo,
      descripcion: descripcion,
      fuente: fuente,
      publicadaEl: publicadaEl,
    );
  }
}
