import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaService extends BaseService {
  Future<List<Noticia>> obtenerNoticias() async {
    final List<dynamic> noticiasJson = await get<List<dynamic>>(
      ApiConstantes.noticiasEndpoint,
      errorMessage: NoticiasConstantes.mensajeError,
    );

    return noticiasJson
        .map<Noticia>(
          (json) => NoticiaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Noticia> crearNoticia(Noticia noticia) async {
    final response = await post(
      ApiConstantes.noticiasEndpoint,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorCreated,
    );
    return NoticiaMapper.fromMap(response);
  }

  Future<Noticia> editarNoticia(Noticia noticia) async {
    final url = '${ApiConstantes.noticiasEndpoint}/${noticia.id}';
    final response = await put(
      url,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorUpdated,
    );
    return NoticiaMapper.fromMap(response);
  }

  Future<void> eliminarNoticia(String id) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$id';
    await delete(url, errorMessage: NoticiasConstantes.errorDelete);
  }

  Future<void> verificarNoticiaExiste(String noticiaId) async {
    await get(
      '${ApiConstantes.noticiasEndpoint}?noticiaId=$noticiaId',
      errorMessage: NoticiasConstantes.errorVerificarNoticiaExiste,
    );
  }

  Future<Map<String, dynamic>> incrementarContadorReportes(
    String noticiaId,
    int valor,
  ) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$noticiaId';

    final response = await patch(
      url,
      data: {'contadorReportes': valor},
      errorMessage: NoticiasConstantes.errorActualizarContadorReportes,
    );

    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> incrementarContadorComentarios(
    String noticiaId,
    int valor,
  ) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$noticiaId';

    final response = await patch(
      url,
      data: {'contadorComentarios': valor},
      errorMessage: NoticiasConstantes.errorActualizarContadorComentarios,
    );

    return response as Map<String, dynamic>;
  }
}