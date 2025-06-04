import 'package:vdenis/api/service/categoria_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaRepository extends CacheableRepository<Categoria> {
  final CategoriaService _categoriaService = di<CategoriaService>();

  DateTime? _lastRefreshed;

  @override
  void validarEntidad(Categoria categoria) {
    validarNoVacio(categoria.nombre, ValidacionConstantes.nombreCategoria);
    validarNoVacio(
      categoria.descripcion,
      ValidacionConstantes.descripcionCategoria,
    );
    validarNoVacio(categoria.imagenUrl, ValidacionConstantes.imagenUrl);
  }

  @override
  Future<List<Categoria>> cargarDatos() async {
    final categorias = await manejarExcepcion(
      () => _categoriaService.obtenerCategorias(),
      mensajeError: CategoriaConstantes.mensajeError,
    );
    _lastRefreshed = DateTime.now();
    return categorias;
  }

  DateTime? get lastRefreshed => _lastRefreshed;

  Future<List<Categoria>> obtenerCategorias({
    bool forzarRecarga = false,
  }) async {
    return obtenerDatos(forzarRecarga: forzarRecarga);
  }

  Future<Categoria> crearCategoria(Categoria categoria) async {
    return manejarExcepcion(() async {
      validarEntidad(categoria);
      final categoriaCreada = await _categoriaService.crearCategoria(categoria);
      invalidarCache();
      return categoriaCreada;
    }, mensajeError: CategoriaConstantes.errorCreated);
  }

  Future<Categoria> actualizarCategoria(Categoria categoria) async {
    return manejarExcepcion(() async {
      validarEntidad(categoria);
      final categoriaActualizada = await _categoriaService.editarCategoria(categoria);
      invalidarCache();
      return categoriaActualizada;
    }, mensajeError: CategoriaConstantes.errorUpdated);
  }

  Future<void> eliminarCategoria(String id) async {
    return manejarExcepcion(() async {
      validarId(id);
      await _categoriaService.eliminarCategoria(id);
      invalidarCache();
    }, mensajeError: CategoriaConstantes.errorDelete);
  }

  void limpiarCache() {
    invalidarCache();
    _lastRefreshed = null;
  }
}
