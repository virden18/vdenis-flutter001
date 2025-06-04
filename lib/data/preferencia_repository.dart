import 'package:vdenis/api/service/preferencia_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/preferencia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaRepository extends CacheableRepository<Preferencia> {
  final PreferenciaService _preferenciaService = di<PreferenciaService>();
  final SecureStorageService _secureStorage = di<SecureStorageService>();

  Preferencia? _cachedPreferencias;

  @override
  void validarEntidad(Preferencia preferencia) {
    validarNoVacio(preferencia.email, 'email del usuario');
  }

  @override
  Future<List<Preferencia>> cargarDatos() async {
    if (_cachedPreferencias == null) {
      await inicializarPreferenciasUsuario();
    }

    return _cachedPreferencias != null ? [_cachedPreferencias!] : [];
  }

  Future<void> inicializarPreferenciasUsuario() async {
    return manejarExcepcion(() async {
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        throw ApiException('No hay usuario autenticado', statusCode: 401);
      }

      try {
        _cachedPreferencias = await _preferenciaService
            .obtenerPreferenciaPorEmail(email);
      } catch (e) {
        if (e is ApiException && e.statusCode == 404) {
          _cachedPreferencias = await _preferenciaService.crearPreferencias(
            email,
          );
        } else {
          rethrow;
        }
      }
    }, mensajeError: 'Error al inicializar preferencias');
  }

  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }

      return _cachedPreferencias?.categoriasSeleccionadas ?? [];
    }, mensajeError: 'Error al obtener categorías seleccionadas');
  }

  Future<void> _actualizarCacheLocal(List<String> categoriaIds) async {
    return manejarExcepcion(() async {
      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();
      }

      final email =
          _cachedPreferencias?.email ??
          (await _secureStorage.getUserEmail() ?? 'usuario@anonymous.com');

      _cachedPreferencias = Preferencia(
        email: email,
        categoriasSeleccionadas: categoriaIds,
      );

      marcarCambiosPendientes();
    }, mensajeError: 'Error al actualizar caché local');
  }

  Future<void> guardarCambiosEnAPI() async {
    return manejarExcepcion(() async {
      if (!hayCambiosPendientes()) {
        return;
      }

      if (_cachedPreferencias == null) {
        await inicializarPreferenciasUsuario();

        if (!hayCambiosPendientes()) {
          return;
        }
      }

      await _preferenciaService.guardarPreferencias(_cachedPreferencias!);

      super.invalidarCache();
    }, mensajeError: 'Error al guardar preferencias');
  }

  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    return _actualizarCacheLocal(categoriaIds);
  }

  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await _actualizarCacheLocal(categorias);
      }
    }, mensajeError: 'Error al agregar categoría');
  }

  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    return manejarExcepcion(() async {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await _actualizarCacheLocal(categorias);
    }, mensajeError: 'Error al eliminar categoría');
  }

  Future<void> limpiarFiltrosCategorias() async {
    return _actualizarCacheLocal([]);
  }

  @override
  void invalidarCache() {
    super.invalidarCache();
    _cachedPreferencias = null;
  }
}
