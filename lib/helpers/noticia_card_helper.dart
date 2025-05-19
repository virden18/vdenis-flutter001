import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/bloc/comentarios/comentario_bloc.dart';
import 'package:vdenis/bloc/comentarios/comentario_event.dart';
import 'package:vdenis/bloc/comentarios/comentario_state.dart';
import 'package:vdenis/bloc/reporte/reporte_bloc.dart';
import 'package:vdenis/bloc/reporte/reporte_event.dart';
import 'package:vdenis/components/reporte_modal.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/core/categoria_helper.dart';
import 'package:vdenis/data/reporte_repository.dart';
import 'package:vdenis/domain/noticia.dart';

class NoticiaCardHelper {
  static Widget buildNoticiaCard(
    Noticia noticia, {
    void Function(Noticia)? onTap,
    void Function(Noticia)? onEdit,
    void Function(Noticia)? onDelete,
    void Function(Noticia)? onComment,
    String? categoriaNombre,
  }) {
    final DateFormat formatter = DateFormat(AppConstants.formatoFecha);
    final String formattedDate = formatter.format(noticia.publicadaEl);

    // Si ya tenemos el nombre de la categoría, lo usamos directamente
    if (categoriaNombre != null) {
      return _buildCard(
        noticia,
        formattedDate,
        categoriaNombre,
        onTap,
        onEdit,
        onDelete,
        onComment,
      );
    }

    // Si no tenemos el nombre, lo buscamos usando CategoryHelper
    return FutureBuilder<String>(
      future:
          noticia.categoriaId != null && noticia.categoriaId!.isNotEmpty
              ? CategoryHelper.getCategoryName(noticia.categoriaId!)
              : Future.value('Sin categoría'),
      builder: (context, snapshot) {
        final String categoryName = snapshot.data ?? 'Cargando categoría...';
        return _buildCard(
          noticia,
          formattedDate,
          categoryName,
          onTap,
          onEdit,
          onDelete,
          onComment,
        );
      },
    );
  }

  // Método para crear el botón de comentarios con contador
  static Widget _buildComentarioButton(
    BuildContext context,
    Noticia noticia,
    void Function(Noticia) onComment,
  ) {
    return _CommentButtonContent(noticia: noticia, onComment: onComment);
  }

  // Método auxiliar para construir la tarjeta con el nombre de categoría
  static Widget _buildCard(
    Noticia noticia,
    String formattedDate,
    String categoryName,
    void Function(Noticia)? onTap,
    void Function(Noticia)? onEdit,
    void Function(Noticia)? onDelete,
    void Function(Noticia)? onComment,
  ) {
    final String categoriaText =
        noticia.categoriaId != null &&
                noticia.categoriaId != NewsConstants.defaultCategoriaId
            ? categoryName
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                ), // Fila de botones para interactuar con la noticia
                Builder(
                  builder: (BuildContext context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Row(
                            children: [
                              FutureBuilder<int>(
                                future: ReporteRepository().obtenerNumeroReportes(
                                  noticia.id!,
                                ),
                                builder: (context, snapshot) {
                                  final count = snapshot.data ?? 0;
                                  return Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.warning_amber,
                                size: 24,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          tooltip: 'Reportes de esta noticia',
                          onPressed:
                              () => showDialog(
                                context: context,
                                builder:
                                    (context) => ReporteModal(
                                      noticiaId: noticia.id!,
                                      onSubmit: (motivo) {
                                        context.read<ReporteBloc>().add(
                                          ReporteCreateEvent(
                                            noticiaId: noticia.id!,
                                            motivo: motivo,
                                          ),
                                        );
                                      },
                                    ),
                              ), // Puedes añadir lógica adicional aquí
                        ),
                        // Botón de comentarios con contador
                        if (onComment != null && noticia.id != null)
                          _buildComentarioButton(context, noticia, onComment),
                        // Botón de edición
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          tooltip: 'Editar noticia',
                          onPressed:
                              onEdit != null ? () => onEdit(noticia) : null,
                        ),
                        // Botón de eliminación
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar noticia',
                          onPressed:
                              onDelete != null ? () => onDelete(noticia) : null,
                        ),
                      ],
                    );
                  },
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

// Widget separado para manejar el estado de la solicitud
class _CommentButtonContent extends StatefulWidget {
  final Noticia noticia;
  final void Function(Noticia) onComment;

  const _CommentButtonContent({required this.noticia, required this.onComment});

  @override
  State<_CommentButtonContent> createState() => _CommentButtonContentState();
}

class _CommentButtonContentState extends State<_CommentButtonContent> {
  // Bandera para rastrear si ya se realizó la solicitud
  bool _requestSent = false;

  @override
  void initState() {
    super.initState();
    // Programar la solicitud para después de que el widget se monte completamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestComments();
    });
  }

  void _checkAndRequestComments() {
    if (!_requestSent && widget.noticia.id != null && mounted) {
      final bloc = context.read<ComentarioBloc>();
      final currentState = bloc.state;

      // Solo enviar solicitud si no es ya el estado actual para esta noticia
      if (!(currentState is NumeroComentariosLoaded &&
          currentState.noticiaId == widget.noticia.id)) {
        setState(() {
          _requestSent = true;
        });

        bloc.add(GetNumeroComentarios(noticiaId: widget.noticia.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComentarioBloc, ComentarioState>(
      buildWhen: (previous, current) {
        // Solo reconstruir si es un estado de NumeroComentariosLoaded para esta noticia
        // o si es un estado de error
        if (current is NumeroComentariosLoaded) {
          return current.noticiaId == widget.noticia.id;
        }
        return current is ComentarioError;
      },
      builder: (context, state) {
        // Inicializar contador
        int numeroComentarios = 0;

        // Actualizar contador si tenemos datos
        if (state is NumeroComentariosLoaded &&
            state.noticiaId == widget.noticia.id) {
          numeroComentarios = state.numeroComentarios;
        }

        // Construir el botón con el contador
        return InkWell(
          onTap: () => widget.onComment(widget.noticia),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  numeroComentarios.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.comment, color: Colors.blue, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
