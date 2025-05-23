import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdenis/api/service/comentario_service.dart';
import 'package:vdenis/core/base_repository.dart';
import 'package:vdenis/domain/comentario.dart';

class ComentarioRepository extends BaseRepository {
  final ComentariosService _service = ComentariosService();

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    try {
      // Verificar si hay caché válida
      final esCacheValido = await _esCacheValido(noticiaId);
      if (esCacheValido) {
        final comentariosCache = await _obtenerComentariosDesdeCache(noticiaId);
        if (comentariosCache != null && comentariosCache.isNotEmpty) {
          return comentariosCache;
        }
      }
      
      // Si no hay caché válida, obtener de la API
      final comentarios = await executeServiceCall(
        serviceCall: () => _service.obtenerComentariosPorNoticia(noticiaId),
        operacion: 'obtener comentarios para noticia $noticiaId',
      );
      
      // Guardar en caché para futuras consultas
      await _guardarComentariosEnCache(noticiaId, comentarios);
      
      return comentarios;
    } catch (e) {
      // En caso de error de red, intentar obtener desde caché aunque esté expirada
      final comentariosCache = await _obtenerComentariosDesdeCache(noticiaId);
      if (comentariosCache != null && comentariosCache.isNotEmpty) {
        debugPrint('⚠️ Usando caché expirada debido a error de red para noticia $noticiaId');
        return comentariosCache;
      }
      
      // Si no hay caché, relanzar la excepción
      rethrow;
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');

    await executeServiceCall(
      serviceCall: () => _service.agregarComentario(noticiaId, texto, autor, fecha),
      operacion: 'agregar comentario a noticia $noticiaId',
    );
    
    // Invalidar la caché para forzar una recarga en la próxima consulta
    await invalidarCacheParaNoticia(noticiaId);
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    try {
      // Verificar si hay caché válida para el contador
      final esCacheValido = await _esCacheValido(noticiaId);
      if (esCacheValido) {
        final contadorCache = await _obtenerContadorDesdeCache(noticiaId);
        if (contadorCache != null) {
          return contadorCache;
        }
      }
      
      // Si no hay caché válida, obtener de la API
      final contador = await executeServiceCall(
        serviceCall: () => _service.obtenerNumeroComentarios(noticiaId),
        operacion: 'obtener número de comentarios para noticia $noticiaId',
      );
      
      // Guardar en caché
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_prefixContadores + noticiaId, contador);
        await prefs.setInt(_prefixTimestamp + noticiaId, DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        debugPrint('🔴 Error al guardar contador en caché: $e');
      }
      
      return contador;
    } catch (e) {
      // En caso de error de red, intentar obtener desde caché aunque esté expirada
      final contadorCache = await _obtenerContadorDesdeCache(noticiaId);
      if (contadorCache != null) {
        debugPrint('⚠️ Usando contador de caché expirado debido a error de red para noticia $noticiaId');
        return contadorCache;
      }
      
      // Si no hay caché, relanzar la excepción
      rethrow;
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
    required String noticiaId,  // Añadido para invalidar la caché
  }) async {
    validateId(comentarioId, mensaje: 'ID de comentario no válido');
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    await executeServiceCall(
      serviceCall: () => _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      ),
      operacion: 'reaccionar a comentario $comentarioId',
    );
    
    // Invalidar la caché para forzar una recarga en la próxima consulta
    await invalidarCacheParaNoticia(noticiaId);
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
    required String noticiaId,  // Añadido para invalidar la caché
  }) async {
    validateId(comentarioId, mensaje: 'ID de comentario no válido');
    validateId(noticiaId, mensaje: 'ID de noticia no válido');
    
    if (texto.isEmpty) {
      return {
        'success': false,
        'message': 'El texto del subcomentario no puede estar vacío.',
      };
    }

    final resultado = await executeServiceCall(
      serviceCall: () => _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      ),
      operacion: 'agregar subcomentario a comentario $comentarioId',
    );
    
    // Invalidar la caché para forzar una recarga en la próxima consulta
    await invalidarCacheParaNoticia(noticiaId);
    
    return resultado;
  }

  /// SHARED PREFERENCES
  /// Manejo de caché para comentarios  
  /// Constantes para las claves de SharedPreferences
  static const String _prefixComentarios = 'comentarios_';
  static const String _prefixContadores = 'contador_comentarios_';
  static const String _prefixTimestamp = 'timestamp_comentarios_';
  
  // Tiempo máximo de validez de la caché (10 minutos)
  static const Duration _tiempoValidezCache = Duration(minutes: 10);

  /// Verifica si la caché para una noticia específica es válida
  Future<bool> _esCacheValido(String noticiaId) async {
    final prefs = await SharedPreferences.getInstance();
    final timestampKey = _prefixTimestamp + noticiaId;
    
    if (!prefs.containsKey(timestampKey)) {
      return false;
    }
    
    final timestamp = prefs.getInt(timestampKey) ?? 0;
    final timestampDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final ahora = DateTime.now();
    
    return ahora.difference(timestampDate) < _tiempoValidezCache;
  }

  /// Guarda comentarios en la caché
  Future<void> _guardarComentariosEnCache(String noticiaId, List<Comentario> comentarios) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Serializar los comentarios
      final List<String> comentariosJson = comentarios.map((c) => jsonEncode(c.toMap())).toList();
      
      // Guardar comentarios serializados
      await prefs.setStringList(_prefixComentarios + noticiaId, comentariosJson);
      
      // Guardar contador
      await prefs.setInt(_prefixContadores + noticiaId, comentarios.length);
      
      // Guardar timestamp
      await prefs.setInt(_prefixTimestamp + noticiaId, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('🟢 Comentarios guardados en caché para noticia $noticiaId');
    } catch (e) {
      debugPrint('🔴 Error al guardar comentarios en caché: $e');
      // Si falla el guardado en caché, continuamos sin interrumpir el flujo
    }
  }

  /// Obtiene comentarios desde la caché
  Future<List<Comentario>?> _obtenerComentariosDesdeCache(String noticiaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final comentariosKey = _prefixComentarios + noticiaId;
      
      if (!prefs.containsKey(comentariosKey)) {
        return null;
      }
      
      final comentariosJson = prefs.getStringList(comentariosKey);
      if (comentariosJson == null || comentariosJson.isEmpty) {
        return null;
      }
      
      // Deserializar los comentarios
      final comentarios = comentariosJson.map((jsonStr) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return ComentarioMapper.fromMap(map);
      }).toList();
      
      debugPrint('🟢 Comentarios cargados desde caché para noticia $noticiaId');
      return comentarios;
    } catch (e) {
      debugPrint('🔴 Error al cargar comentarios desde caché: $e');
      return null;
    }
  }

  /// Obtiene el número de comentarios desde la caché
  Future<int?> _obtenerContadorDesdeCache(String noticiaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contadorKey = _prefixContadores + noticiaId;
      
      if (!prefs.containsKey(contadorKey)) {
        return null;
      }
      
      final contador = prefs.getInt(contadorKey);
      debugPrint('🟢 Contador de comentarios cargado desde caché para noticia $noticiaId: $contador');
      return contador;
    } catch (e) {
      debugPrint('🔴 Error al cargar contador desde caché: $e');
      return null;
    }
  }

  /// Invalida la caché para una noticia específica
  Future<void> invalidarCacheParaNoticia(String noticiaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefixComentarios + noticiaId);
      await prefs.remove(_prefixContadores + noticiaId);
      await prefs.remove(_prefixTimestamp + noticiaId);
      debugPrint('🟠 Caché invalidada para noticia $noticiaId');
    } catch (e) {
      debugPrint('🔴 Error al invalidar caché: $e');
    }
  }

  /// Limpia toda la caché de comentarios
  Future<void> limpiarCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_prefixComentarios) || 
            key.startsWith(_prefixContadores) || 
            key.startsWith(_prefixTimestamp)) {
          await prefs.remove(key);
        }
      }
      
      debugPrint('🟠 Caché de comentarios completamente limpiada');
    } catch (e) {
      debugPrint('🔴 Error al limpiar caché de comentarios: $e');
    }
  }
}
