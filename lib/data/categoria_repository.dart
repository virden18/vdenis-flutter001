import 'package:vdenis/api/service/categoria_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/categoria.dart';

class CategoriaRepository extends BaseRepository {
  final CategoriaService _categoriaService = CategoriaService();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    return get(
      serviceGet: _categoriaService.getCategorias,
      operacion: 'cargar categorías',
    );
  }

  Future<void> crearCategoria(Map<String, dynamic> categoriaData) async {
    return create(
      serviceCreate: _categoriaService.crearCategoria,
      data: categoriaData,
      operacion: 'crear categoría',
    ); 
  }

  Future<void> actualizarCategoria(
    String id,
    Map<String, dynamic> categoriaData,
  ) async {
    return update(
      serviceUpdate: _categoriaService.editarCategoria,
      id: id,
      data: categoriaData,
      operacion: 'actualizar categoría',
    );
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    return delete(
      serviceDelete: _categoriaService.eliminarCategoria,
      id: id,
      operacion: 'eliminar categoría',
    );
  }
}
