import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/theme/colors.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;
  final String noticiaId;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
    required this.noticiaId,
  });
  @override
  Widget build(BuildContext context) {
    // La fecha ya viene formateada desde el backend
    final fecha = subcomentario.fecha;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                subcomentario.autor,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subcomentario.texto,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            fecha,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.gray09,
              fontStyle: FontStyle.italic,
            ),
          ),          const SizedBox(height: 8),
          // Botones de reacción (like/dislike)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.thumb_up_sharp,
                  size: 16,
                ),
                onPressed: () => _handleReaction(context, 'like'),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.blue11,
                  backgroundColor: AppColors.blue02,
                  padding: const EdgeInsets.all(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                subcomentario.likes.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue11,
                ),
              ),
              const SizedBox(width: 12),              IconButton(
                icon: const Icon(
                  Icons.thumb_down_sharp,
                  size: 16,
                ),
                onPressed: () => _handleReaction(context, 'dislike'),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.destructive,
                  backgroundColor: AppColors.red03,
                  padding: const EdgeInsets.all(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                subcomentario.dislikes.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.destructive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }  void _handleReaction(BuildContext context, String tipoReaccion) {
    // Capturamos una referencia al bloc fuera del Future.delayed
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = noticiaId;
    
    // Determinamos correctamente los IDs para la reacción
    String comentarioId = '';
    String? padreId;
    
    // Si tiene ID propio, lo usamos directamente
    if (subcomentario.id != null && subcomentario.id!.isNotEmpty) {
      comentarioId = subcomentario.id!;
      
      // Si además tiene idSubComentario, ese es el padre
      if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
        padreId = subcomentario.idSubComentario;
      }
    } 
    // Si no tiene ID propio pero tiene idSubComentario, usamos ese como su ID
    else if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
      comentarioId = subcomentario.idSubComentario!;
    }
    
    // Agregamos la reacción con los IDs correctos
    comentarioBloc.add(
      AddReaccion(
        comentarioId,
        tipoReaccion,
        true,
        padreId,
      ),
    );
    comentarioBloc.add(LoadComentarios(currentNoticiaId));
  }
}
