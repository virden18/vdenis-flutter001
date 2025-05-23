import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/categoria.dart';

class CategoriaHelper {
  static String obtenerNombreCategoria(String categoriaId, List<Categoria> categorias) {
    if (categoriaId.isEmpty || categoriaId == CategoriaConstantes.defaultcategoriaId) {
      return CategoriaConstantes.defaultcategoriaId;
    }
    
    final categoria = categorias.firstWhere(
      (c) => c.id == categoriaId,
      orElse: () => const Categoria(id: '', nombre: 'Desconocida', descripcion: '', imagenUrl: '')
    );
    return categoria.nombre;
  }
}