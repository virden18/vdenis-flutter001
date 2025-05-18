import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/api/service/categoria_cache_service.dart';
import 'package:vdenis/bloc/noticias/noticia_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_event.dart';
import 'package:vdenis/bloc/preferencia/preferencia_bloc.dart';
import 'package:vdenis/bloc/preferencia/preferencia_event.dart';
import 'package:vdenis/bloc/preferencia/preferencia_state.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/helpers/message_helper.dart';
import 'package:watch_it/watch_it.dart';

class PreferenciaScreen extends StatelessWidget {
  const PreferenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PreferenciaBloc()..add(const CargarPreferencias()),
      child: const PreferenciaView(),
    );
  }
}

class PreferenciaView extends StatelessWidget {
  const PreferenciaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Preferencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _guardarYAplicarFiltros(context),
          ),
        ],
      ),
      body: BlocBuilder<PreferenciaBloc, PreferenciaState>(
        buildWhen: (previous, current) => 
          previous.categoriasSeleccionadas != current.categoriasSeleccionadas,
        builder: (context, state) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderContent(),
                SizedBox(height: 20),
                _CategoriasList(),
                SizedBox(height: 24),
                _SaveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _guardarYAplicarFiltros(BuildContext context) {
    // Simplemente delegamos al método del botón de guardar
    const _SaveButton()._guardarYAplicarPreferencias(context);
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona las categorías que te interesan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Selecciona las categorías que te interesan para personalizar tu feed de noticias. Solo verás noticias de las categorías que elijas.',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _CategoriasList extends StatefulWidget {
  const _CategoriasList();

  @override
  State<_CategoriasList> createState() => _CategoriasListState();
}

class _CategoriasListState extends State<_CategoriasList> {
  late Future<List<Categoria>> _categoriasFuture;
  final CategoryCacheService _categoriaCacheService = di<CategoryCacheService>();

  @override
  void initState() {
    super.initState();
    // Inicializamos el future una sola vez en el initState
    _categoriasFuture = _categoriaCacheService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categoria>>(
      future: _categoriasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar categorías: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _categoriasFuture = _categoriaCacheService.getCategories();
                    });
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No hay categorías disponibles',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          );
        }

        final categorias = snapshot.data!;
        
        // Optimizamos la construcción de la lista utilizando ListView.builder en lugar de Column
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            final categoria = categorias[index];
            // El ID puede ser nulo, así que manejamos ese caso            if (categoria.id == null) return const SizedBox.shrink();
            
            return _CategoriaListItem(
              key: ValueKey('categoria_${categoria.id}'),  // Añadimos una key para optimizar la reconstrucción
              categoria: categoria,
            );
          },
        );
      },
    );
  }
}

class _CategoriaListItem extends StatelessWidget {
  const _CategoriaListItem({super.key, required this.categoria});
  
  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenciaBloc, PreferenciaState>(
      buildWhen: (previous, current) {
        final prevContains = previous.categoriasSeleccionadas.contains(categoria.id);
        final currentContains = current.categoriasSeleccionadas.contains(categoria.id);
        return prevContains != currentContains;
      },
      builder: (context, state) {
        final isSelected = state.categoriasSeleccionadas.contains(categoria.id);
        
        return ListTile(
          title: Text(categoria.nombre),
          subtitle: Text(categoria.descripcion),
          trailing: Switch(
            value: isSelected,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) => _toggleCategoria(context, value),
          ),
          onTap: () => _toggleCategoria(context, !isSelected),
        );
      },
    );
  }
  
  void _toggleCategoria(BuildContext context, bool selected) {
    context.read<PreferenciaBloc>().add(
      CambiarCategoria(
        categoria: categoria.id!,
        seleccionada: selected,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _guardarYAplicarPreferencias(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 12,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Guardar y aplicar preferencias',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
  
  void _guardarYAplicarPreferencias(BuildContext context) {
    final preferenciasState = context.read<PreferenciaBloc>().state;
    
    // Guardar preferencias en el repositorio
    context.read<PreferenciaBloc>().add(
      SavePreferencias(categoriasSeleccionadas: preferenciasState.categoriasSeleccionadas),
    );
    
    // Mostrar mensaje de confirmación
    MessageHelper.showSnackBar(
      context,
      'Preferencias guardadas correctamente',
      isSuccess: true,
    );

    // Aplicar filtro en la pantalla de noticias si hay categorías seleccionadas
    if (preferenciasState.categoriasSeleccionadas.isNotEmpty) {
      final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);
      noticiaBloc.add(
        FilterNoticiasByPreferencias(preferenciasState.categoriasSeleccionadas),
      );
    } else {
      // Si no hay categorías seleccionadas, mostrar todas las noticias
      final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);
      noticiaBloc.add(const ClearNoticiasFilters());
    }
    
    // Volver a la pantalla anterior con resultado positivo
    Navigator.pop(context, true);
  }
}