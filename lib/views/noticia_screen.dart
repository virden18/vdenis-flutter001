import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_bloc.dart';
import 'package:vdenis/bloc/noticias/noticia_event.dart';
import 'package:vdenis/bloc/noticias/noticia_state.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/error_helper.dart';
import 'package:vdenis/helpers/message_helper.dart';
import 'package:vdenis/helpers/noticia_card_helper.dart';
import 'package:vdenis/views/categoria_screen.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoticiaBloc(
        noticiaRepository: NoticiaRepository(),
        categoriaRepository: CategoriaRepository(),
      )..add(const LoadNoticias()),
      child: const NoticiaView(),
    );
  }
}

class NoticiaView extends StatelessWidget {
  const NoticiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoticiaBloc, NoticiaState>(
      listener: (context, state) {
        if (state is NoticiaError) {
          MessageHelper.showSnackBar(
            context,
            state.message,
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

  PreferredSizeWidget _buildAppBar(BuildContext context, NoticiaState state) {
    return AppBar(
      title: const Text(NewsConstants.tituloAppNoticias),
      backgroundColor: Colors.blueGrey,
      actions: [
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
            
            // Verificar que el contexto siga montado
            if (!currentContext.mounted) return;
            
            // Recargar categorías al volver
            if (result == true) {
              currentContext.read<NoticiaBloc>().add(const LoadCategorias());
              currentContext.read<NoticiaBloc>().add(const LoadNoticias());
            }
          },
        ),
        if (state is NoticiaLoaded)
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

  Widget _buildBodyContent(BuildContext context, NoticiaState state) {
    if (state is NoticiaInitial || state is NoticiaLoading) {
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
    } else if (state is NoticiaError) {
      final errorMessage = ErrorHelper.getErrorMessageAndColor(state.statusCode);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage['message'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NoticiaBloc>().add(const LoadNoticias());
              },
              child: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      );
    } else if (state is NoticiaLoaded) {
      final noticias = state.noticias;
      if (noticias.isEmpty) {
        return const Center(
          child: Text(
            NewsConstants.listaVaciaNoticias,
            style: TextStyle(fontSize: 16),
          ),
        );
      } else {
        return _buildNoticiasList(context, noticias, state.categoriasCache);
      }
    }
    
    return const Center(child: Text('Estado no reconocido'));
  }

  Widget _buildNoticiasList(
    BuildContext context, 
    List<Noticia> noticias,
    Map<String, String> categoriasCache,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // Capturar el contexto actual antes de la operación async
        final currentContext = context;
        // Verificar que el contexto siga montado
        if (!currentContext.mounted) return;
        
        currentContext.read<NoticiaBloc>().add(const LoadNoticias());
      },
      child: ListView.builder(
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          final noticia = noticias[index];
          return NoticiaCardHelper.buildNoticiaCard(
            noticia,
            onEdit: (noticia) {
              _showNoticiaForm(context, noticia: noticia);
            },
            onDelete: (noticia) {
              _confirmarEliminarNoticia(context, noticia);
            },
            categoriaNombre: categoriasCache[noticia.categoriaId] ?? 'Sin categoría',
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
      builder: (context) => AlertDialog(
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
      currentContext.read<NoticiaBloc>().add(DeleteNoticia(noticia));
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
    String id = isEditing ? noticia.id : '';

    String selectedCategoriaId = noticia?.categoriaId ?? NewsConstants.defaultCategoriaId;

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
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'El título es obligatorio' : null,
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'La descripción es obligatoria' : null,
                  ),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'La fuente es obligatoria' : null,
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
                      UpdateNoticia(
                        id: id,
                        noticia: newNoticia,
                      ),
                    );
                    MessageHelper.showSnackBar(
                      context,
                      SuccessConstants.successUpdated,
                      isSuccess: true,
                    );
                  } else {
                    context.read<NoticiaBloc>().add(CreateNoticia(newNoticia));
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
    // Aquí no necesitamos capturar el contexto para problemas de async gap
    // ya que FutureBuilder maneja esto internamente y no utiliza el contexto después
    // de operaciones asíncronas fuera del builder
    return FutureBuilder<List<Categoria>>(
      future: CategoriaRepository().getCategorias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
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
        
        final String value = items.any((item) => item.value == initialValue)
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
}
