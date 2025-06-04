import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/bloc/comentario/comentario_state.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';
import 'package:vdenis/theme/colors.dart';

class CommentInputForm extends StatelessWidget {
  final String noticiaId;
  final TextEditingController comentarioController;
  final String? respondingToId;
  final String? respondingToAutor;
  final VoidCallback onCancelarRespuesta;

  const CommentInputForm({
    super.key,
    required this.noticiaId,
    required this.comentarioController,
    required this.respondingToId,
    required this.respondingToAutor,
    required this.onCancelarRespuesta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        const Divider(color: AppColors.gray05, thickness: 1),
        if (respondingToId != null) _buildRespondingTo(context),
        const SizedBox(height: 8),
        TextField(
          controller: comentarioController,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText:
                respondingToId == null
                    ? 'Escribe tu comentario'
                    : 'Escribe tu respuesta...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.gray09),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gray05),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gray05),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: AppColors.gray01,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _handleSubmit(context),
          icon: const Icon(Icons.send),
          label: Text(
            respondingToId == null ? 'Publicar comentario' : 'Enviar respuesta',
            style: theme.textTheme.labelMedium?.copyWith(color: AppColors.gray01),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: AppColors.gray01,
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildRespondingTo(BuildContext context) {
    return Builder(builder: (context) {
      final theme = Theme.of(context);
      
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.blue02,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blue03),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Respondiendo a $respondingToAutor',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: AppColors.blue13,
                ),
              ),
            ),            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onCancelarRespuesta,
              tooltip: 'Cancelar respuesta',
              padding: EdgeInsets.zero,
              color: AppColors.blue11,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.blue02,
                padding: EdgeInsets.zero,
              ),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    });
  }

  void _handleSubmit(BuildContext context) {
    if (comentarioController.text.trim().isEmpty) {
      SnackBarHelper.mostrarInfo(
        context,
        mensaje: 'El comentario no puede estar vacío',
      );
      return;
    }
    final fecha = DateTime.now().toIso8601String();
    final bloc = context.read<ComentarioBloc>();

    if (respondingToId == null) {
      final nuevoComentario = Comentario(
        id: '',
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: false,
      );

      bloc.add(AddComentario(noticiaId, nuevoComentario));
    } else {
      final nuevoSubComentario = Comentario(
        id: '', 
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios:
            [],
        isSubComentario: true,
        idSubComentario:
            respondingToId,
      );

      bloc.add(AddSubcomentario(nuevoSubComentario));
    }

    int totalComentariosActuales = 0;
    if (bloc.state is ComentarioLoaded) {
      final comentariosActuales = (bloc.state as ComentarioLoaded).comentarios;
      totalComentariosActuales = comentariosActuales.length;
      for (var comentario in comentariosActuales) {
        if (comentario.subcomentarios != null) {
          totalComentariosActuales += comentario.subcomentarios!.length;
        }
      }
    }
    
    final nuevoTotal = totalComentariosActuales + 1;
    bloc.add(ActualizarContadorComentarios(noticiaId, nuevoTotal));
    
    comentarioController.clear();
    onCancelarRespuesta();

    SnackBarHelper.mostrarExito(
      context,
      mensaje: 'Comentario agregado con éxito',
    );
  }
}