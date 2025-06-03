import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/components/comentarios/subcomment_card.dart';
import 'package:vdenis/theme/colors.dart';

class CommentCard extends StatelessWidget {
  final Comentario comentario;
  final String noticiaId;
  final Function(String, String) onResponder;

  const CommentCard({
    super.key,
    required this.comentario,
    required this.noticiaId,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {    
    // La fecha ya viene formateada del backend, la usamos directamente
    final fecha = comentario.fecha;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.autor,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  comentario.texto,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  fecha,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.gray09,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_up_sharp,
                        size: 18,
                      ),
                      onPressed: () => _handleReaction(context, 'like'),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.blue11,
                        backgroundColor: AppColors.blue02,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      comentario.likes.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue11,
                      ),
                    ),                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_down_sharp,
                        size: 18,
                      ),
                      onPressed: () => _handleReaction(context, 'dislike'),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.destructive,
                        backgroundColor: AppColors.red03,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      comentario.dislikes.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.destructive,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: Icon(Icons.reply, size: 20, color: theme.colorScheme.primary),
                      label: Text(
                        'Responder',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: AppColors.blue02,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => onResponder(comentario.id ?? '', comentario.autor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (comentario.subcomentarios != null &&
              comentario.subcomentarios!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 20, right: 4, bottom: 8),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.blue03, width: 2),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comentario.subcomentarios!.length,                itemBuilder: (context, index) => SubcommentCard(
                  subcomentario: comentario.subcomentarios![index],
                  noticiaId: noticiaId,
                ),
              ),
            ),
        ],
      ),
    );
  }  void _handleReaction(BuildContext context, String tipoReaccion) {
    // Capturamos una referencia al bloc fuera del Future.delayed
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = noticiaId;
    
    // Primero enviamos el evento de reacción
    comentarioBloc.add(
      AddReaccion(
        comentario.id ?? '', 
        tipoReaccion, 
        true, 
        null 
      ),
    );
    comentarioBloc.add(LoadComentarios(currentNoticiaId));
  }
}