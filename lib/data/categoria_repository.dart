import 'package:flutter/material.dart';
import 'package:vdenis/api/service/categoria_service.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';

class CategoriaRepository {
  final CategoriaService _categoriaService = CategoriaService();

  /// Obtiene todas las categorías desde el repositorio
  Future<List<Categoria>> getCategorias() async {
    try {
      return await _categoriaService.getCategorias();
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  Future<void> crearCategoria(Map<String, dynamic> categoriaData) async {
    try {
      // Llama al método del repositorio para crear la categoría
      await _categoriaService.crearCategoria(categoriaData);
      debugPrint('Categoría creada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al crear categoría: $e');
      rethrow;
    }
  }

  Future<void> actualizarCategoria(String id, Map<String, dynamic> categoriaData) async {
    try {
      // Llama al método del repositorio para editar la categoría
      await _categoriaService.editarCategoria(id, categoriaData);
      debugPrint('Categoría con ID $id actualizada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al actualizar categoría $id: $e');
      rethrow;
    }
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    try {
      await _categoriaService.eliminarCategoria(id);
    } catch (e) {
      if (e is ApiException) {
        // Propaga el mensaje contextual de ApiException
        throw Exception('Error en el servicio de categorías: ${e.message}');
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
