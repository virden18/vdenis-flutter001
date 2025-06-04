import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/data/reporte_repository.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _noticiaService = NoticiaService();
  final reporteRepo = ReporteRepository();

  @override
  void validarEntidad(Noticia noticia) {
    validarNoVacio(noticia.titulo, ValidacionConstantes.tituloNoticia);
    validarNoVacio(
      noticia.descripcion,
      ValidacionConstantes.descripcionNoticia,
    );
    validarNoVacio(noticia.fuente, ValidacionConstantes.fuenteNoticia);

    validarFechaNoFutura(
      noticia.publicadaEl,
      ValidacionConstantes.fechaNoticia,
    );
  }

  Future<List<Noticia>> obtenerNoticias() async {
    return manejarExcepcion(
      () => _noticiaService.obtenerNoticias(),
      mensajeError: NoticiasConstantes.mensajeError,
    );
  }

  Future<Noticia> crearNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.crearNoticia(noticia);
    }, mensajeError: NoticiasConstantes.errorCreated);
  }

  Future<Noticia> editarNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.editarNoticia(noticia);
    }, mensajeError: NoticiasConstantes.errorUpdated);
  }

  Future<void> eliminarNoticia(String id) async {
    return manejarExcepcion(() async {
      validarId(id);
      await reporteRepo.eliminarReportesPorNoticia(id);
      await _noticiaService.eliminarNoticia(id);
    }, mensajeError: NoticiasConstantes.errorDelete);
  }

  Future<Map<String, dynamic>> incrementarContadorReportes(
    String noticiaId,
    int valor,
  ) async {
    return manejarExcepcion(() {
      validarId(noticiaId);
      return _noticiaService.incrementarContadorReportes(noticiaId, valor);
    }, mensajeError: NoticiasConstantes.errorActualizarContadorReportes);
  }

  Future<Map<String, dynamic>> incrementarContadorComentarios(
    String noticiaId,
    int valor,
  ) async {
    return manejarExcepcion(() {
      validarId(noticiaId);
      return _noticiaService.incrementarContadorComentarios(noticiaId, valor);
    }, mensajeError: NoticiasConstantes.errorActualizarContadorComentarios);
  }
}
