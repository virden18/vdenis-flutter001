import 'package:flutter/material.dart';
import 'package:vdenis/theme/colors.dart';

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool ordenAscendente;
  final Function(bool) onOrdenChanged;
  final String? titulo;
  final VoidCallback onSearchTap;
  final bool isSearchVisible;

  const CommentAppBar({
    super.key,
    required this.ordenAscendente,
    required this.onOrdenChanged,
    required this.onSearchTap,
    required this.isSearchVisible,
    this.titulo,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        titulo != null ? 'Comentarios: $titulo' : 'Comentarios',
        style: theme.appBarTheme.titleTextStyle,
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.gray01),
        onPressed: () => Navigator.pop(context),
      ),      actions: [
        IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isSearchVisible ? Icons.search_off : Icons.search,
              key: ValueKey<bool>(isSearchVisible),
              color: AppColors.gray01,
            ),
          ),
          tooltip: isSearchVisible ? 'Ocultar búsqueda' : 'Mostrar búsqueda',
          onPressed: onSearchTap,
        ),
        Tooltip(
          message: ordenAscendente 
              ? 'Ordenar por más recientes' 
              : 'Ordenar por más antiguos',
          child: IconButton(
            onPressed: () => onOrdenChanged(!ordenAscendente),
            icon: Icon(
              ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
              color: AppColors.gray01,
            ),
            tooltip: ordenAscendente 
                ? 'Ordenar por más antiguos'
                : 'Ordenar por más recientes',
          ),
        ),
      ],
    );
  }
}