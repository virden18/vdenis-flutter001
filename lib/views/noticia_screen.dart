import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/api/service/categoria_cache_service.dart';
import 'package:vdenis/bloc/comentarios/comentario_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_event.dart';
import 'package:vdenis/bloc/noticias/noticia_state.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/error_helper.dart';
import 'package:vdenis/helpers/message_helper.dart';
import 'package:vdenis/helpers/noticia_card_helper.dart';
import 'package:vdenis/views/categoria_screen.dart';
import 'package:vdenis/views/comentarios/comentarios_screen.dart';
import 'package:vdenis/views/preferencia_screen.dart';
import 'package:watch_it/watch_it.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Asegurarse de que las categorías estén precargadas
    _precargarCategorias();    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // Crear el bloque de noticias e iniciar la carga
            return NoticiaBloc()..add(const NoticiasLoadEvent());
          },
        ),
        BlocProvider(
          create: (context) {
            // Crear el bloque de comentarios
            return ComentarioBloc();
          },
        ),
      ],
      child: const NoticiaView(),
    );
  }

  // Método para precargar categorías
  static Future<void> _precargarCategorias() async {
    try {
      final categoriaCacheService = di<CategoryCacheService>();
      if (!categoriaCacheService.hasCachedCategories) {
        await categoriaCacheService.refreshCategories();
      }
    } catch (e) {
      debugPrint('Error al precargar categorías: ${e.toString()}');
    }
  }
}

class NoticiaView extends StatelessWidget {
  const NoticiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoticiaBloc, NoticiasState>(
      listener: (context, state) {
        if (state is NoticiasError) {
          MessageHelper.showSnackBar(
            context,
            state.errorMessage,
            statusCode: state.statusCode,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: Container(
            color: Colors.grey[200],
            child: _buildBodyContent(context, state),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showNoticiaForm(context),
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, NoticiasState state) {
    // Obtener una referencia al bloc para verificar si hay filtros aplicados
    final noticiaBloc = BlocProvider.of<NoticiaBloc>(context);

    return AppBar(
      title: const Text(NewsConstants.tituloAppNoticias),
      backgroundColor: Colors.blueGrey,
      actions: [
        // Mostrar botón para limpiar filtros solo cuando hay filtros aplicados
        if (noticiaBloc.filtrosAplicados)
          IconButton(
            icon: const Icon(Icons.filter_none),
            tooltip: 'Limpiar filtros',
            onPressed: () {
              // Dispatch event para limpiar filtros
              noticiaBloc.add(const ClearNoticiasFilters());
              MessageHelper.showSnackBar(
                context,
                'Filtros eliminados',
                isSuccess: true,
              );
            },
          ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Mis preferencias',
          onPressed: () => _navegarAPreferencias(context),
        ),
        IconButton(
          icon: const Icon(Icons.category),
          tooltip: 'Categorías',
          onPressed: () async {
            // Capturar el contexto actual antes de la operación async
            final currentContext = context;

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoriaScreenDos(),
              ),
            );

            // Recargar categorías al volver
            if (result == true) {
              // Refrescar caché de categorías primero
              final categoriaCacheService = di<CategoryCacheService>();
              await categoriaCacheService.refreshCategories();
              // Luego recargar noticias
              if (!currentContext.mounted) return;
              currentContext.read<NoticiaBloc>().add(const NoticiasLoadEvent());
            }
          },
        ),
        if (state is NoticiasLoaded)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Actualizado:', style: TextStyle(fontSize: 10)),
                  Text(
                    _formatLastUpdated(state.lastUpdated),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildBodyContent(BuildContext context, NoticiasState state) {
    if (state is NoticiasInitial || state is NoticiasLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(NewsConstants.mensajeCargando),
          ],
        ),
      );
    } else if (state is NoticiasError) {
      final errorMessage = ErrorHelper.getErrorMessageAndColor(
        state.statusCode,
      );
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage['message'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NoticiaBloc>().add(const NoticiasLoadEvent());
              },
              child: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      );
    } else if (state is NoticiasLoaded) {
      final noticias = state.noticiasList;
      if (noticias.isEmpty) {
        return const Center(
          child: Text(
            NewsConstants.listaVaciaNoticias,
            style: TextStyle(fontSize: 16),
          ),
        );
      } else {
        // Usar lista de noticias directamente sin caché de categorías
        // El NoticiaCardHelper se encargará de obtener los nombres de categoría
        return _buildNoticiasList(context, noticias);
      }
    }

    return const Center(child: Text('Estado no reconocido'));
  }

  Widget _buildNoticiasList(BuildContext context, List<Noticia> noticias) {        return RefreshIndicator(
      onRefresh: () async {
        // Capturar el contexto actual antes de la operación async
        final currentContext = context;
        // Verificar que el contexto siga montado
        if (!currentContext.mounted) return;

        currentContext.read<NoticiaBloc>().add(const NoticiasLoadEvent());
      },
      child: ListView.builder(
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          final noticia = noticias[index];

          return NoticiaCardHelper.buildNoticiaCard(
            noticia,
            onEdit: (noticia) => _showNoticiaForm(context, noticia: noticia),
            onDelete: (noticia) => _confirmarEliminarNoticia(context, noticia),
            onComment: (noticia) {
              // Capturar el contexto actual antes de la operación async
              final currentContext = context;
              // Verificar que el contexto siga montado
              if (!currentContext.mounted) return;
              // Navegar a la pantalla de comentarios 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<ComentarioBloc>(currentContext),
                    child: ComentariosScreen(noticiaId: noticia.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmarEliminarNoticia(
    BuildContext context,
    Noticia noticia,
  ) async {
    // Capturar el contexto antes de la operación async
    final currentContext = context;

    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar la noticia "${noticia.titulo}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    // Verificar que el contexto siga montado
    if (!currentContext.mounted) return;

    if (confirmar == true) {
      currentContext.read<NoticiaBloc>().add(
        NoticiasDeleteEvent(noticia.id ?? ''),
      );
      MessageHelper.showSnackBar(
        currentContext,
        SuccessConstants.successDeleted,
        isSuccess: true,
      );
    }
  }

  void _showNoticiaForm(BuildContext context, {Noticia? noticia}) {
    final bool isEditing = noticia != null;
    final String title = isEditing ? 'Editar Noticia' : 'Crear Noticia';
    final String buttonText = isEditing ? 'Actualizar' : 'Crear';
    String id = isEditing ? (noticia.id ?? '') : '';

    String selectedCategoriaId =
        noticia?.categoriaId ?? NewsConstants.defaultCategoriaId;

    final formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController(
      text: noticia?.titulo ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: noticia?.descripcion ?? '',
    );
    final TextEditingController fuenteController = TextEditingController(
      text: noticia?.fuente ?? '',
    );
    final TextEditingController urlImagenController = TextEditingController(
      text: noticia?.urlImagen ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'El título es obligatorio'
                                : null,
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'La descripción es obligatoria'
                                : null,
                  ),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator:
                        (value) =>
                            value?.isEmpty ?? true
                                ? 'La fuente es obligatoria'
                                : null,
                  ),
                  TextFormField(
                    controller: urlImagenController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la Imagen',
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildCategoriasDropdown(
                    context,
                    selectedCategoriaId,
                    (value) => selectedCategoriaId = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final Noticia newNoticia = Noticia(
                    id: isEditing ? id : '',
                    titulo: tituloController.text,
                    descripcion: descripcionController.text,
                    fuente: fuenteController.text,
                    publicadaEl: noticia?.publicadaEl ?? DateTime.now(),
                    urlImagen:
                        urlImagenController.text.isNotEmpty
                            ? urlImagenController.text
                            : NewsConstants.urlImagen,
                    categoriaId: selectedCategoriaId,
                  );

                  Navigator.pop(dialogContext);

                  if (isEditing) {
                    context.read<NoticiaBloc>().add(
                      NoticiasUpdateEvent(
                        id,
                        newNoticia.titulo,
                        newNoticia.descripcion,
                        newNoticia.fuente,
                        newNoticia.publicadaEl,
                        newNoticia.urlImagen,
                        newNoticia.categoriaId ?? '',
                      ),
                    );
                    MessageHelper.showSnackBar(
                      context,
                      SuccessConstants.successUpdated,
                      isSuccess: true,
                    );
                  } else {
                    context.read<NoticiaBloc>().add(
                      NoticiasCreateEvent(
                        newNoticia.titulo,
                        newNoticia.descripcion,
                        newNoticia.fuente,
                        newNoticia.publicadaEl,
                        newNoticia.urlImagen,
                        newNoticia.categoriaId ?? '',
                      ),
                    );
                    MessageHelper.showSnackBar(
                      context,
                      SuccessConstants.successCreated,
                      isSuccess: true,
                    );
                  }
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriasDropdown(
    BuildContext context,
    String initialValue,
    Function(String) onChanged,
  ) {
    // Usar CategoryCacheService a través del método estático di de watch_it
    final categoriaCacheService = di<CategoryCacheService>();
    return FutureBuilder<List<Categoria>>(
      future: categoriaCacheService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        if (snapshot.hasError) {
          return const Text(
            'Error al cargar categorías',
            style: TextStyle(color: Colors.red),
          );
        }

        final categorias = snapshot.data ?? [];

        if (categorias.isEmpty) {
          return const Text(
            'No hay categorías disponibles',
            style: TextStyle(color: Colors.grey),
          );
        }

        final items = [
          const DropdownMenuItem<String>(
            value: NewsConstants.defaultCategoriaId,
            child: Text('Sin categoría'),
          ),
          ...categorias.map((categoria) {
            return DropdownMenuItem<String>(
              value: categoria.id,
              child: Text(categoria.nombre),
            );
          }),
        ];

        final String value =
            items.any((item) => item.value == initialValue)
                ? initialValue
                : NewsConstants.defaultCategoriaId;

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Categoría',
            border: OutlineInputBorder(),
          ),
          value: value,
          items: items,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        );
      },
    );
  }

  void _navegarAPreferencias(BuildContext context) async {
    // Capturar el contexto actual antes de la operación async
    final currentContext = context;

    // Navegar a la pantalla de preferencias
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: BlocProvider.of<NoticiaBloc>(currentContext),
              child: const PreferenciaScreen(),
            ),
      ),
    );

    // Si regresamos con resultado true, aplicar filtros de preferencias
    if (result == true && currentContext.mounted) {
      // Se aplican los filtros automáticamente al guardar las preferencias
    }
  }
}
