import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/bloc/comentario/comentario_state.dart';
import 'package:vdenis/domain/comentario.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';
import 'package:vdenis/components/comentarios/comment_card.dart';

class CommentList extends StatelessWidget {
  final String noticiaId;
  final Function(String, String) onResponderComentario;

  const CommentList({
    super.key,
    required this.noticiaId,
    required this.onResponderComentario,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComentarioBloc, ComentarioState>(
      listener: (context, state) {
        if (state is ComentarioError) {
          SnackBarHelper.manejarError(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReaccionLoading) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: const Color(0x0D000000), 
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          );
        } else if (state is ComentarioLoaded) {
          return _buildList(context, state.comentarios);
        } else if (state is ComentarioError) {
          return _buildErrorState(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<Comentario> comentarios) {
    // Recibir context
    if (comentarios.isEmpty) {
      return const Center(
        child: Text(
          'No hay comentarios que coincidan con tu búsqueda',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: comentarios.length,
      itemBuilder:
          (context, index) => CommentCard(
            comentario: comentarios[index],
            noticiaId: noticiaId,
            onResponder: onResponderComentario,
          ),
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    // Recibir context como parámetro
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar comentarios',
            style: TextStyle(color: Colors.red[700]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed:
                () =>
                    context.read<ComentarioBloc>()
                      ..add(LoadComentarios(noticiaId)),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
