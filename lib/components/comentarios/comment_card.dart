import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/components/comentarios/subcomment_card.dart';
import 'package:vdenis/theme/colors.dart';

class CommentCard extends StatefulWidget {
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
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _mostrarSubcomentarios = false;

  @override
  Widget build(BuildContext context) {    
    final fecha = widget.comentario.fecha;
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
                  widget.comentario.autor,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.blue13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.comentario.texto,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  fecha,
                  style: theme.textTheme.bodySmall
                ),
                const SizedBox(height: 8),                
                Row(
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
                      widget.comentario.likes.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue11,
                      ),
                    ),                    
                    const SizedBox(width: 16),
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
                      widget.comentario.dislikes.toString(),
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
                        style: theme.textTheme.labelMedium
                      ),                      
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: AppColors.blue02,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => widget.onResponder(widget.comentario.id ?? '', widget.comentario.autor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.comentario.subcomentarios != null &&
              widget.comentario.subcomentarios!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextButton.icon(
                    icon: Icon(
                      _mostrarSubcomentarios ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      _mostrarSubcomentarios ? 'Ocultar respuestas' : 'Mostrar ${widget.comentario.subcomentarios!.length} respuestas',
                      style: theme.textTheme.labelSmall
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarSubcomentarios = !_mostrarSubcomentarios;
                      });
                    },
                  ),
                ),
                if (_mostrarSubcomentarios)
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
                      itemCount: widget.comentario.subcomentarios!.length,
                      itemBuilder: (context, index) => SubcommentCard(
                        subcomentario: widget.comentario.subcomentarios![index],
                        noticiaId: widget.noticiaId,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }  

  void _handleReaction(BuildContext context, String tipoReaccion) {
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = widget.noticiaId;
    comentarioBloc.add(
      AddReaccion(
        widget.comentario.id ?? '', 
        tipoReaccion, 
        true, 
        null 
      ),
    );
    comentarioBloc.add(LoadComentarios(currentNoticiaId));
  }
}