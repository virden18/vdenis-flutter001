import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/categorias/categorias_bloc.dart';
import 'package:vdenis/bloc/categorias/categorias_event.dart';
import 'package:vdenis/bloc/categorias/categorias_state.dart';
import 'package:vdenis/components/app_drawer.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/helpers/categoria_card_helper.dart';
import 'package:vdenis/helpers/message_helper.dart';

class CategoriaScreenDos extends StatelessWidget {
  const CategoriaScreenDos({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocConsumer<CategoriaBloc, CategoriaState>(
            listener: (context, state) {
              if (state is CategoriaError) {
                MessageHelper.showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Categorías de Noticias'),
                  centerTitle: true,
                ),
                drawer: const AppDrawer(),
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _mostrarDialogCategoria(context),
                  backgroundColor: Colors.blueGrey,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                body: CategoriaCardHelper.construirCuerpoCategorias(
                  context,
                  state,
                  mostrarDialogCategoria: _mostrarDialogCategoria,
                  confirmarEliminarCategoria: _confirmarEliminarCategoria,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _mostrarDialogCategoria(
    BuildContext context, {
    Categoria? categoria,
  }) async {
    final bool isEditing = categoria != null;
    final String title = isEditing ? 'Editar Categoría' : 'Crear Categoría';
    final String buttonText = isEditing ? 'Actualizar' : 'Crear';

    final TextEditingController nombreController = TextEditingController(
      text: categoria?.nombre ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: categoria?.descripcion ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: categoria?.imagenUrl ?? '',
    );

    final formKey = GlobalKey<FormState>();

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
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Nombre de la categoría',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Descripción de la categoría',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de Imagen',
                      hintText: 'URL de la imagen representativa',
                    ),
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
                  Navigator.pop(dialogContext);
                  if (isEditing) {
                    context.read<CategoriaBloc>().add(
                      CategoriaUpdateEvent(
                        id: categoria.id!,
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        imagenUrl: imagenUrlController.text.isNotEmpty
                            ? imagenUrlController.text
                            : NewsConstants.urlCategoria,
                      ),
                    );
                    MessageHelper.showSnackBar(
                      context,
                      'Categoría actualizada exitosamente',
                      isSuccess: true,
                    );
                  } else {
                    context.read<CategoriaBloc>().add(
                      CategoriaCreateEvent(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        imagenUrl: imagenUrlController.text.isNotEmpty
                            ? imagenUrlController.text
                            : NewsConstants.urlCategoria,
                      ),
                    );
                    MessageHelper.showSnackBar(
                      context,
                      'Categoría agregada exitosamente',
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

  Future<void> _confirmarEliminarCategoria(
    BuildContext context,
    Categoria categoria,
  ) async {
    // Capturar el contexto antes de la operación async
    final currentContext = context;
    
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la categoría "${categoria.nombre}"?',
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
      currentContext.read<CategoriaBloc>().add(CategoriaDeleteEvent(id: categoria.id!));
      MessageHelper.showSnackBar(
        currentContext,
        SuccessConstants.successDeleted,
        isSuccess: true,
      );
    }
  }
}
