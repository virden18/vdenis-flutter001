import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/theme/colors.dart';

class CommentSearchBar extends StatelessWidget {
  final TextEditingController busquedaController;
  final VoidCallback onSearch;
  final String noticiaId;

  const CommentSearchBar({
    super.key,
    required this.busquedaController,
    required this.onSearch,
    required this.noticiaId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: busquedaController,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Buscar en comentarios...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.gray09),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: busquedaController,
                builder: (context, value, child) {
                  return value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          color: AppColors.gray09,
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            busquedaController.clear();
                            context.read<ComentarioBloc>()
                              .add(LoadComentarios(noticiaId));
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.gray05),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.gray05),
              ),
              filled: true,
              fillColor: AppColors.gray01,
            ),
          ),
        ),
        const SizedBox(width: 8),        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: AppColors.gray01,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}