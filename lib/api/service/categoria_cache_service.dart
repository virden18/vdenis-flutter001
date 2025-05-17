import 'package:flutter/foundation.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:watch_it/watch_it.dart';

/// Servicio singleton para cachear categorías
class CategoryCacheService {
  // Instancia singleton private
  static final CategoryCacheService _instance = CategoryCacheService._internal();

  // Constructor factory que retorna la misma instancia
  factory CategoryCacheService() => _instance;

  // Constructor privado
  CategoryCacheService._internal();

  // Inyectamos el repositorio de categorías usando di
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  // Cache de categorías
  List<Categoria>? _categorias;
  
  // Timestamp de la última actualización
  DateTime? _lastRefreshed;

  /// Retorna la lista de categorías en cache
  /// Si no hay categorías en cache, realiza una carga desde la API
  Future<List<Categoria>> getCategories() async {
    try {
      // Si no hay categorías en cache o es la primera vez, obtener desde la API
      if (_categorias == null) {
        await refreshCategories();
      }
      // Retorna una copia de la lista para evitar modificaciones externas
      return List<Categoria>.from(_categorias ?? []);
    } catch (e) {
      debugPrint('Error al obtener categorías desde cache: ${e.toString()}');
      // En caso de error, retornamos una lista vacía
      return [];
    }
  }

  /// Refresca las categorías desde la API
  Future<void> refreshCategories() async {
    try {
      debugPrint('Refrescando categorías desde la API');
      _categorias = await _categoriaRepository.getCategorias();
      _lastRefreshed = DateTime.now();
      debugPrint('Categorías actualizadas: ${_categorias?.length ?? 0} items');
    } catch (e) {
      debugPrint('❌ Error al refrescar categorías: ${e.toString()}');
      // No modificamos _categorias si hay error para mantener datos anteriores
      rethrow;
    }
  }

  /// Verifica si las categorías están cargadas en cache
  bool get hasCachedCategories => _categorias != null;

  /// Obtiene el timestamp de la última actualización
  DateTime? get lastRefreshed => _lastRefreshed;
  
  /// Limpia la cache de categorías
  void clear() {
    _categorias = null;
    _lastRefreshed = null;
    debugPrint('Cache de categorías limpiado');
  }
}
