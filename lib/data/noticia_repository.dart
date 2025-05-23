import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaRepository extends BaseRepository {
  final NoticiaService _noticiaService = NoticiaService();

  /// Carga noticias desde el repositorio
  Future<List<Noticia>> getNoticias() async {
    final List<Noticia> noticias = await get(
      serviceGet: _noticiaService.getNoticias,
      operacion: 'cargar noticias',
    );
    if (noticias.isEmpty) {
      return [];
    }
    return noticias;
  }

  Future<void> crearNoticia(Map<String, dynamic> noticiaData) async {
    return create(
      serviceCreate: _noticiaService.createNoticia,
      data: noticiaData,
      operacion: 'crear noticia',
    );
  }

  Future<void> actualizarNoticia(
    String id,
    Map<String, dynamic> noticiaData,
  ) async {
    return update(
      serviceUpdate: _noticiaService.updateNoticia,
      id: id,
      data: noticiaData,
      operacion: 'actualizar noticia',
    );
  }

  /// Elimina una categoría
  Future<void> eliminarNoticia(String id) async {
    return delete(
      serviceDelete: _noticiaService.deleteNoticia,
      id: id,
      operacion: 'eliminar noticia',
    );
  }
}
