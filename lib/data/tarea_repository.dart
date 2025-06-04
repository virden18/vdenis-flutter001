import 'package:vdenis/api/service/tareas_service.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/domain/tarea_cache_prefs.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/core/services/shared_preferences_service.dart';
import 'package:watch_it/watch_it.dart';

class TareasRepository extends BaseRepository<Tarea> {
  final _tareaService = di<TareaService>();
  final _secureStorage = di<SecureStorageService>();
  final _sharedPreferences = di<SharedPreferencesService>();

  static const String _tareasCacheKey = 'tareas_cache_prefs';
  String? usuarioAutenticado;

  TareaCachePrefs _fromJson(Map<String, dynamic> json) =>
      TareaCachePrefsMapper.fromMap(json);
  Map<String, dynamic> _toJson(TareaCachePrefs cache) => cache.toMap();

  TareasRepository();

  Future<String> _obtenerUsuarioAutenticado() async {
    usuarioAutenticado ??= await _secureStorage.getUserEmail();
    return usuarioAutenticado!;
  }

  @override
  void validarEntidad(Tarea tarea) {
    validarNoVacio(tarea.titulo, ValidacionConstantes.tituloTarea);
  }

  Future<TareaCachePrefs?> _obtenerCache({
    TareaCachePrefs? defaultValue,
  }) async {
    return _sharedPreferences.getObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      fromJson: _fromJson,
      defaultValue: defaultValue,
    );
  }

  Future<bool> _guardarEnCache(List<Tarea> tareas) async {
    final usuario = await _obtenerUsuarioAutenticado();
    return _sharedPreferences.saveObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      value: TareaCachePrefs(usuario: usuario, misTareas: tareas),
      toJson: _toJson,
    );
  }

  Future<bool> _actualizarCache(
    TareaCachePrefs Function(TareaCachePrefs cache) updateFn,
  ) async {
    return _sharedPreferences.updateObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      updateFn: (current) => updateFn(current!),
      fromJson: _fromJson,
      toJson: _toJson,
    );
  }

  Future<List<Tarea>> obtenerTareasUsuario(String usuario) async {
    List<Tarea> tareasUsuario = await manejarExcepcion(
      () => _tareaService.obtenerTareas(usuario),
      mensajeError: TareasConstantes.mensajeError,
    );
    return tareasUsuario;
  }

  Future<List<Tarea>> obtenerTareas({bool forzarRecarga = false}) async {
    return manejarExcepcion(() async {
      List<Tarea> tareas = [];
      final usuario = await _obtenerUsuarioAutenticado();

      TareaCachePrefs? tareasCache = await _obtenerCache(
        defaultValue: TareaCachePrefs(usuario: usuario, misTareas: tareas),
      );

      if (usuario != tareasCache?.usuario) {
        await _sharedPreferences.remove(_tareasCacheKey);
        tareasCache = null;
      }

      if (forzarRecarga != true &&
          tareasCache != null &&
          tareasCache.misTareas.isNotEmpty) {
        tareas = tareasCache.misTareas;
      } else {
        tareas = await obtenerTareasUsuario(usuario);
        await _guardarEnCache(tareas);
      }
      return tareas;
    }, mensajeError: TareasConstantes.mensajeError);
  }

  Future<Tarea> agregarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarEntidad(tarea);
      final usuario = await _obtenerUsuarioAutenticado();

      final tareaConEmail =
          (tarea.usuario!.isEmpty) ? tarea.copyWith(usuario: usuario) : tarea;

      final nuevaTarea = await _tareaService.crearTarea(tareaConEmail);
      await _actualizarCache(
        (cache) => cache.copyWith(misTareas: [...cache.misTareas, nuevaTarea]),
      );
      return nuevaTarea;
    }, mensajeError: TareasConstantes.errorCrear);
  }

  Future<void> eliminarTarea(String tareaId) async {
    return manejarExcepcion(() async {
      validarId(tareaId);
      await _tareaService.eliminarTarea(tareaId);
      await _actualizarCache((cache) {
        final tareasFiltradas =
            cache.misTareas.where((t) => t.id != tareaId).toList();

        return cache.copyWith(misTareas: tareasFiltradas);
      });
    }, mensajeError: TareasConstantes.errorEliminar);
  }

  Future<Tarea> actualizarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarId(tarea.id);
      validarEntidad(tarea);

      final tareaActualizada = await _tareaService.actualizarTarea(tarea);
      await _actualizarCache((cache) {
        final nuevasTareas =
            cache.misTareas.map((t) {
              return t.id == tarea.id ? tareaActualizada : t;
            }).toList();

        return cache.copyWith(misTareas: nuevasTareas);
      });
      return tareaActualizada;
    }, mensajeError: TareasConstantes.errorActualizar);
  }

  Future<Tarea> actualizarTareaEnCache(Tarea tarea) async {
    return manejarExcepcion(() async {
      final tareasCacheadas = await _obtenerCache();

      if (tareasCacheadas != null) {
        final List<Tarea> tareas = List.from(tareasCacheadas.misTareas);
        final index = tareas.indexWhere((t) => t.id == tarea.id);

        if (index >= 0) {
          tareas[index] = tarea;

          await _guardarEnCache(tareas);
        }
      }

      return tarea;
    }, mensajeError: TareasConstantes.errorActualizar);
  }

  Future<void> limpiarCache() async {
    usuarioAutenticado = null;
  }
}
