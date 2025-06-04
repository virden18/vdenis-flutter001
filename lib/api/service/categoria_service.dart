import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/categoria.dart';

class CategoriaService extends BaseService {
  Future<List<Categoria>> obtenerCategorias() async {
    final List<dynamic> categoriasJson = await get<List<dynamic>>(
      ApiConstantes.categoriaEndpoint,
      errorMessage: CategoriaConstantes.mensajeError,
    );

    return categoriasJson
        .map<Categoria>(
          (json) => CategoriaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Categoria> crearCategoria(Categoria categoria) async {
    final response = await post(
      ApiConstantes.categoriaEndpoint,
      data: categoria.toMap(),
      errorMessage: CategoriaConstantes.errorCreated,
    );
    return CategoriaMapper.fromMap(response);
  }

  Future<Categoria> editarCategoria(Categoria categoria) async {
    final url = '${ApiConstantes.categoriaEndpoint}/${categoria.id}';
    final response = await put(
      url,
      data: categoria.toMap(),
      errorMessage: CategoriaConstantes.errorUpdated,
    );
    return CategoriaMapper.fromMap(response);
  }

  Future<void> eliminarCategoria(String id) async {
    final url = '${ApiConstantes.categoriaEndpoint}/$id';
    await delete(url, errorMessage: CategoriaConstantes.errorDelete);
  }
}
