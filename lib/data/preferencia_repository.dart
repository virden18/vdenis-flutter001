import 'package:flutter/foundation.dart';
import 'package:vdenis/api/service/preferencia_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/core/service/secure_storage_service.dart';
import 'package:vdenis/domain/preferencia.dart';

class PreferenciaRepository extends BaseRepository {
  final PreferenciaService _preferenciaService = PreferenciaService();
  final SecureStorageService _secureStorageService = SecureStorageService();

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return executeServiceCall(
      serviceCall: () async {
        // Si no hay caché o es la primera vez, obtener de la API
        _cachedPreferencias ??= await _preferenciaService.getPreferencias();
        return _cachedPreferencias!.categoriasSeleccionadas;
      },
      operacion: 'obtener categorías seleccionadas',
    ).catchError((error) {
      // En caso de error, devolver lista vacía para no romper la UI
      debugPrint('Error al obtener categorías seleccionadas: $error');
      return <String>[];
    });
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return executeServiceCall(
      serviceCall: () async {
        // Si no hay caché o es la primera vez, obtener de la API
        _cachedPreferencias ??= await _preferenciaService.getPreferencias();

        // Actualizar el objeto en caché
        final email = await _secureStorageService.getUserEmail();
        _cachedPreferencias = Preferencia(
          categoriasSeleccionadas: categoriaIds,
          email: email ?? '',
        );

        // Guardar en la API
        await _preferenciaService.guardarPreferencias(_cachedPreferencias!);
      },
      operacion: 'guardar categorías seleccionadas',
    );
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return executeServiceCall(
      serviceCall: () async {
        final categorias = await obtenerCategoriasSeleccionadas();
        if (!categorias.contains(categoriaId)) {
          categorias.add(categoriaId);
          await guardarCategoriasSeleccionadas(categorias);
        }
      },
      operacion: 'agregar categoría al filtro',
    );
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return executeServiceCall(
      serviceCall: () async {
        final categorias = await obtenerCategoriasSeleccionadas();
        categorias.remove(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      },
      operacion: 'eliminar categoría del filtro',
    );
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    return executeServiceCall(
      serviceCall: () async {
        await guardarCategoriasSeleccionadas([]);

        // Limpiar también la caché
        if (_cachedPreferencias != null) {
          _cachedPreferencias = Preferencia.empty();
        }
      },
      operacion: 'limpiar filtros de categorías',
    );
  }

  /// Limpia la caché para forzar una recarga desde la API
  void invalidarCache() {
    _cachedPreferencias = null;
  }

  /// Obtiene las preferencias completas
  Future<Preferencia> obtenerPreferencias() {
    return getWithCache(
      cachedData: _cachedPreferencias,
      fetchData: _preferenciaService.getPreferencias,
      updateCache: (Preferencia preferencias) {
        _cachedPreferencias = preferencias;
      },
      operacion: 'obtener preferencias',
    );
  }
}
