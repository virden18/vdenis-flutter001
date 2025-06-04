import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/core/services/secure_storage_service.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/domain/tarea_cache_prefs.dart';
import 'package:watch_it/watch_it.dart';

class TareaCacheService {
  final String _cacheKey = 'tareas_cache';
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  final SharedPreferences _sharedPreferences = di<SharedPreferences>();

  Future<void> guardarTareas(List<Tarea> tareas) async {
    try {
      final email = await _secureStorage.getUserEmail();
      if (email == null || email.isEmpty) {
        return;
      }

      final tareaCachePrefs = TareaCachePrefs(
        usuario: email,
        misTareas: tareas,
      );

      final jsonData = tareaCachePrefs.toJson();
      
      await _sharedPreferences.setString(_cacheKey, jsonData);
    } catch (e) {
      debugPrint('Error al guardar tareas en caché: $e');
    }
  }

  Future<List<Tarea>?> obtenerTareas() async {
    try {
      final currentEmail = await _secureStorage.getUserEmail();
      if (currentEmail == null || currentEmail.isEmpty) {
        return null;
      }

      final jsonData = _sharedPreferences.getString(_cacheKey);
      if (jsonData == null || jsonData.isEmpty) {
        return null;
      }

      final tareaCachePrefs = TareaCachePrefsMapper.fromJson(jsonData);

      if (tareaCachePrefs.usuario != currentEmail) {
        await _sharedPreferences.remove(_cacheKey);
        return null;
      }

      return tareaCachePrefs.misTareas;
    } catch (e) {
      debugPrint('Error al obtener tareas desde caché: $e');
      return null;
    }
  }

  Future<void> limpiarCache() async {
    try {
      await _sharedPreferences.remove(_cacheKey);
    } catch (e) {
      debugPrint('Error al limpiar caché de tareas: $e');
    }
  }

  Future<bool> hayCache() async {
    try {
      final tareas = await obtenerTareas();
      return tareas != null && tareas.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> obtenerUltimaActualizacion() async {
    try {
      final timestamp = _sharedPreferences.getInt('${_cacheKey}_timestamp');
      if (timestamp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  Future<void> actualizarTimestamp() async {
    try {
      await _sharedPreferences.setInt(
        '${_cacheKey}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('Error al actualizar timestamp de caché: $e');
    }
  }
}
