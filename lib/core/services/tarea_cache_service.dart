import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/domain/tarea_cache_prefs.dart';
import 'package:watch_it/watch_it.dart';

class TareaCacheService {
  final String _cacheKey = 'tareas_cache';
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  final SharedPreferences _sharedPreferences = di<SharedPreferences>();

  /// Guarda las tareas en SharedPreferences
  Future<void> guardarTareas(List<Tarea> tareas) async {
    try {
      // Obtenemos el email del usuario para asociar las tareas
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        // No podemos guardar sin un usuario
        return;
      }

      // Creamos el objeto de cache
      final tareaCachePrefs = TareaCachePrefs(
        email: email,
        misTareas: tareas,
      );

      // Convertimos a JSON
      final jsonData = tareaCachePrefs.toJson();
      
      // Guardamos en SharedPreferences
      await _sharedPreferences.setString(_cacheKey, jsonData);
    } catch (e) {
      // Si hay un error, simplemente no guardamos en caché
      print('Error al guardar tareas en caché: $e');
    }
  }

  /// Obtiene las tareas desde SharedPreferences
  Future<List<Tarea>?> obtenerTareas() async {
    try {
      // Obtenemos el email actual para verificar que las tareas pertenecen a este usuario
      final currentEmail = await _secureStorage.getUserEmail();
      if (currentEmail == null || currentEmail.isEmpty) {
        // Sin usuario, no hay caché
        return null;
      }

      // Obtenemos el JSON desde SharedPreferences
      final jsonData = _sharedPreferences.getString(_cacheKey);
      if (jsonData == null || jsonData.isEmpty) {
        return null;
      }

      // Decodificamos el objeto de caché
      final tareaCachePrefs = TareaCachePrefsMapper.fromJson(jsonData);
      
      // Verificamos que las tareas pertenecen al usuario actual
      if (tareaCachePrefs.email != currentEmail) {
        // Las tareas pertenecen a otro usuario, borramos la caché
        await _sharedPreferences.remove(_cacheKey);
        return null;
      }

      return tareaCachePrefs.misTareas;
    } catch (e) {
      // Si hay un error, simplemente retornamos null
      print('Error al obtener tareas desde caché: $e');
      return null;
    }
  }

  /// Limpia la caché de tareas
  Future<void> limpiarCache() async {
    try {
      await _sharedPreferences.remove(_cacheKey);
    } catch (e) {
      print('Error al limpiar caché de tareas: $e');
    }
  }

  /// Verifica si hay caché de tareas para el usuario actual
  Future<bool> hayCache() async {
    try {
      final tareas = await obtenerTareas();
      return tareas != null && tareas.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene la fecha de la última actualización
  Future<DateTime?> obtenerUltimaActualizacion() async {
    try {
      final timestamp = _sharedPreferences.getInt('${_cacheKey}_timestamp');
      if (timestamp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza el timestamp de la caché
  Future<void> actualizarTimestamp() async {
    try {
      await _sharedPreferences.setInt(
        '${_cacheKey}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Ignorar errores
    }
  }
}
