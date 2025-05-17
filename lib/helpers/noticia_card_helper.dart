import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/core/categoria_helper.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaCardHelper {
  static Widget buildNoticiaCard(
    Noticia noticia, {
    void Function(Noticia)? onTap,
    void Function(Noticia)? onEdit,
    void Function(Noticia)? onDelete,
    String? categoriaNombre,
  }) {
    final DateFormat formatter = DateFormat(AppConstants.formatoFecha);
    final String formattedDate = formatter.format(noticia.publicadaEl);
    
    // Si ya tenemos el nombre de la categoría, lo usamos directamente
    if (categoriaNombre != null) {
      return _buildCard(noticia, formattedDate, categoriaNombre, onTap, onEdit, onDelete);
    }
    
    // Si no tenemos el nombre, lo buscamos usando CategoryHelper
    return FutureBuilder<String>(
      future: noticia.categoriaId != null && noticia.categoriaId!.isNotEmpty
          ? CategoryHelper.getCategoryName(noticia.categoriaId!)
          : Future.value('Sin categoría'),
      builder: (context, snapshot) {
        final String categoryName = snapshot.data ?? 'Cargando categoría...';
        return _buildCard(noticia, formattedDate, categoryName, onTap, onEdit, onDelete);
      },
    );
  }
  
  // Método auxiliar para construir la tarjeta con el nombre de categoría
  static Widget _buildCard(
    Noticia noticia,
    String formattedDate,
    String categoryName,
    void Function(Noticia)? onTap,
    void Function(Noticia)? onEdit,
    void Function(Noticia)? onDelete,
  ) {
    final String categoriaText = noticia.categoriaId != null && 
                               noticia.categoriaId != NewsConstants.defaultCategoriaId
      ? 'Categoría: $categoryName'
      : 'Sin categoría';

    return Column(
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.zero, // Sin margen entre los elementos
          elevation: 0.0, // Sin sombra
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sin bordes redondeados
          ),
          child: InkWell(
            onTap: onTap != null ? () => onTap(noticia) : null,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              noticia.titulo,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              noticia.descripcion,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noticia.fuente,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            categoriaText,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 125,
                      height: 80,
                      margin: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: Image.network(
                          noticia.urlImagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Reemplazar los botones existentes con botones de edición y eliminación
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botón de edición
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueGrey),
                      tooltip: 'Editar noticia',
                      onPressed: onEdit != null ? () => onEdit(noticia) : null,
                    ),
                    // Botón de eliminación
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar noticia',
                      onPressed: onDelete != null ? () => onDelete(noticia) : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 213, 208, 208),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        ),
      ],
    );
  }
}
