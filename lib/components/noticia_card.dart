import 'package:flutter/material.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/views/comentarios_screen.dart';
import 'package:vdenis/components/reporte_dialog.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit;
  final String categoriaNombre;
  final VoidCallback? onReport;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.categoriaNombre,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categoría
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
            child: Row(
              children: [
                Text(
                  categoriaNombre,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noticia.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        noticia.descripcion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        noticia.fuente,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatDate(noticia.publicadaEl),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    noticia.urlImagen.isNotEmpty
                        ? noticia.urlImagen
                        : 'https://picsum.photos/200/300',
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 100,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Botón Comentarios
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.comment_outlined,
                    label: 'Comentarios',
                    badge: noticia.contadorComentarios,
                    badgeColor: theme.colorScheme.primary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ComentariosScreen(
                                noticiaId: noticia.id!,
                                noticiaTitulo: noticia.titulo,
                              ),
                        ),
                      );
                    },
                  ),
                ),

                // Botón Reportar
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.flag_outlined,
                    label: 'Reportar',
                    badge: noticia.contadorReportes,
                    badgeColor: Colors.red,
                    onPressed: () {
                      if (onReport != null) {
                        onReport!();
                      } else {
                        ReporteDialog.mostrarDialogoReporte(
                          context: context,
                          noticia: noticia,
                        );
                      }
                    },
                  ),
                ),

                // Botón Editar
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.edit_outlined,
                    label: 'Editar',
                    onPressed: onEdit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    int? badge,
    Color? badgeColor,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        alignment: Alignment.center,
      ),
      icon: Stack(
        clipBehavior:
            Clip.none,
        children: [
          Icon(icon, size: 20),
          if (badge != null && badge > 0)
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(
                  4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor ?? Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 16, // Aumentado
                  minHeight: 16, // Aumentado
                ),
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Aumentado
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}
