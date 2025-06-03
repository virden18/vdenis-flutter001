import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/categoria/categoria_bloc.dart';
import 'package:vdenis/bloc/categoria/categoria_event.dart';
import 'package:vdenis/bloc/categoria/categoria_state.dart';
import 'package:vdenis/bloc/noticia/noticia_bloc.dart';
import 'package:vdenis/bloc/noticia/noticia_event.dart';
import 'package:vdenis/bloc/preferencia/preferencia_bloc.dart';
import 'package:vdenis/bloc/preferencia/preferencia_event.dart';
import 'package:vdenis/bloc/preferencia/preferencia_state.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';
import 'package:vdenis/helpers/snackbar_manager.dart';

class PreferenciaScreen extends StatelessWidget {
  const PreferenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    // pero solo si no está mostrándose el SnackBar de conectividad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PreferenciaBloc>(
          create: (context) => PreferenciaBloc()..add(LoadPreferences()),
        ),
        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: BlocConsumer<PreferenciaBloc, PreferenciaState>(
        listener: (context, state) {
          if (state is PreferenciaError) {
            SnackBarHelper.manejarError(context, state.error);
          } else if (state is PreferenciasSaved) {
            noticiaBloc.add(
              FilterNoticiasByPreferenciasEvent(state.categoriasSeleccionadas),
            );
            SnackBarHelper.mostrarExito(
              context,
              mensaje: 'Preferencias guardadas correctamente',
            );
            if (context.mounted) {
              Navigator.pop(context, state.categoriasSeleccionadas);
            }
          }
        },
        builder: (context, prefState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Preferencias'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Eliminar filtros',
                  onPressed:
                      () => context.read<PreferenciaBloc>().add(ResetFilters()),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: _construirCuerpoPreferencias(context, prefState),
            bottomNavigationBar: _construirBarraInferior(context, prefState),
          );
        },
      ),
    );
  }

  Widget _construirCuerpoPreferencias(
    BuildContext context,
    PreferenciaState prefState,
  ) {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, catState) {
        if (catState is CategoriaLoading ||
            prefState is PreferenciaLoading ||
            prefState is PreferenciasSaved) {
          return const Center(child: CircularProgressIndicator());
        } else if (catState is CategoriaError) {
          return _construirWidgetError(
            context,
            'Error al cargar categorías: ${catState.error.message}',
            () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
          );
        } else if (prefState is PreferenciaError) {
          return _construirWidgetError(
            context,
            'Error de preferencias: ${prefState.mensaje}',
            () => context.read<PreferenciaBloc>().add(LoadPreferences()),
          );
        } else if (catState is CategoriaLoaded) {
          final categorias = catState.categorias;
          return _construirListaCategorias(context, prefState, categorias);
        }
        return const Center(child: Text('Estado desconocido'));
      },
    );
  }

  Widget _construirListaCategorias(
    BuildContext context,
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    final theme = Theme.of(context);
    if (categorias.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        if (categoria.id == null || categoria.id!.isEmpty) {
          return const ListTile(
            title: Text('Categoría sin identificador válido'),
            leading: Icon(Icons.error_outline, color: Colors.red),
          );
        }

        return BlocBuilder<PreferenciaBloc, PreferenciaState>(
          buildWhen: (previous, current) {
            if (previous is PreferenciasLoaded &&
                current is PreferenciasLoaded) {
              final prevSelected = previous.categoriasSeleccionadas.contains(
                categoria.id,
              );
              final currSelected = current.categoriasSeleccionadas.contains(
                categoria.id,
              );
              return prevSelected != currSelected;
            }
            return true;
          },
          builder: (context, state) {
            final isSelected =
                state is PreferenciasLoaded &&
                state.categoriasSeleccionadas.contains(categoria.id);

            return CheckboxListTile(
              title: Text(
                categoria.nombre,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              value: isSelected,
              onChanged:
                  (_) => _toggleCategoria(context, categoria.id!, isSelected),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: theme.colorScheme.primary,
            );
          },
        );
      },
    );
  }

  Widget _construirBarraInferior(BuildContext context, PreferenciaState state) {
    final theme = Theme.of(context);
    final bool isEnabled = state is! PreferenciaError && state is! PreferenciaLoading;
    final int numCategorias = state is PreferenciasLoaded ? state.categoriasSeleccionadas.length : 0;

    return SafeArea(
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state is PreferenciaError
                    ? 'Error al cargar preferencias'
                    : 'Categorías seleccionadas: $numCategorias',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: state is PreferenciaError ? Colors.red : null,
                ),
              ),
              ElevatedButton(
                onPressed:
                    isEnabled ? () => _aplicarFiltros(context, state) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.surface,
                ),
                child: const Text('Aplicar filtros'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirWidgetError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _toggleCategoria(
    BuildContext context,
    String categoriaId,
    bool isSelected,
  ) {
    final currentState = context.read<PreferenciaBloc>().state;
    if (currentState is PreferenciasLoaded) {
      context.read<PreferenciaBloc>().add(
        ChangeCategory(category: categoriaId, selected: !isSelected),
      );
    }
  }

  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    if (state is PreferenciaError) {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: 'No se pueden aplicar los filtros debido a un error',
      );
      return;
    }

    if (state is PreferenciasLoaded) {
      final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);
      noticiaBloc.add(
        FilterNoticiasByPreferenciasEvent(state.categoriasSeleccionadas),
      );
      context.read<PreferenciaBloc>().add(
        SavePreferences(selectedCategories: state.categoriasSeleccionadas),
      );
    } else {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: 'Estado de preferencias inválido',
      );
    }
  }
}
