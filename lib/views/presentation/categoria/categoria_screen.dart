import 'package:flutter/material.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  CategoriaScreenState createState() => CategoriaScreenState();
}

class CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaRepository _categoriaService = CategoriaRepository();
  List<Categoria> categorias = [];
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedCategorias = await _categoriaService.getCategorias();

      // Verificar si el widget sigue montado antes de actualizar el estado
      if (mounted) {
        setState(() {
          categorias = fetchedCategorias;
          isLoading = false;
        });
      }
    } catch (e) {
      // Verificar si el widget sigue montado antes de actualizar el estado
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
        });

        String errorMessage = 'Error desconocido';
        Color errorColor = Colors.grey;

        if (e is ApiException) {
          final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
          errorMessage = errorData['message'];
          errorColor = errorData['color'];
        }

        // Verificar nuevamente antes de usar ScaffoldMessenger
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.blueGrey,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(
                child: Text(
                  'Ocurrió un error al cargar las categorías.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
              : categorias.isEmpty
              ? const Center(
                child: Text(
                  'No hay categorías disponibles.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final categoria = categorias[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: InkWell(
                      onTap: () => _editarCategoria(categoria),
                      child: ListTile(
                        title: Text(
                          categoria.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (categoria.descripcion.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Text(categoria.descripcion),
                              ),
                            Text(
                              'ID: ${categoria.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: categoria.descripcion.isNotEmpty,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child:
                              categoria.imagenUrl.isNotEmpty
                                  ? Image.network(
                                    categoria.imagenUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.category,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                  : const Icon(
                                    Icons.category,
                                    color: Colors.grey,
                                  ),
                        ),
                        // Modificar el trailing en el ListTile para incluir botón de edición junto al de eliminar
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón de editar
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarCategoria(categoria),
                            ),
                            // Botón de eliminar (ya existente)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () => _confirmarEliminarCategoria(categoria),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarCategoria,
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Future<Map<String, dynamic>?> _mostrarDialogCategoria(
    BuildContext context, {
    Categoria? categoria,
  }) async {
    final TextEditingController nombreController = TextEditingController(
      text: categoria?.nombre ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: categoria?.descripcion ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: categoria?.imagenUrl ?? '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre de la categoría',
                  ),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Descripción de la categoría',
                  ),
                ),
                TextField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL de Imagen',
                    hintText: 'URL de la imagen representativa',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty &&
                    descripcionController.text.isNotEmpty) {
                  if (imagenUrlController.text.isEmpty) {
                    imagenUrlController.text = Constants.urlCategoria;
                  }
                  Navigator.pop(context, {
                    'nombre': nombreController.text.toString(),
                    'descripcion': descripcionController.text.toString(),
                    'imagenUrl': imagenUrlController.text.toString(),
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No puede haber campos vacíos'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _agregarCategoria() async {
    final nuevaCategoriaData = await _mostrarDialogCategoria(context);
    if (nuevaCategoriaData != null) {
      try {
        final nuevaCategoria = Categoria(
          id: '',
          nombre: nuevaCategoriaData['nombre'],
          descripcion: nuevaCategoriaData['descripcion'],
          imagenUrl: nuevaCategoriaData['imagenUrl'] ?? Constants.urlCategoria,
        );

        await _categoriaService.crearCategoria(
          nuevaCategoria,
        ); // Llama al servicio
        await _loadCategorias(); // Recarga las categorías

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría agregada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Error al agregar la categoría';
          Color backgroundColor = Colors.red;

          if (e is ApiException) {
            final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
            errorMessage = '${errorData['message']}: ${e.message}';
            backgroundColor = errorData['color'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: backgroundColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    final categoriaEditadaData = await _mostrarDialogCategoria(
      context,
      categoria: categoria,
    );

    if (categoriaEditadaData != null) {
      try {
        final categoriaActualizada = Categoria(
          id: categoria.id,
          nombre: categoriaEditadaData['nombre'],
          descripcion:
              categoriaEditadaData['descripcion'], // Usar el nuevo valor
          imagenUrl: categoriaEditadaData['imagenUrl'] ?? categoria.imagenUrl,
        );

        await _categoriaService.actualizarCategoria(
          categoria.id!,
          categoriaActualizada,
        );

        _loadCategorias(); // Recargar las categorías

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Error al actualizar la categoría';
          Color backgroundColor = Colors.red;

          if (e is ApiException) {
            final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
            errorMessage = '${errorData['message']}: ${e.message}';
            backgroundColor = errorData['color'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: backgroundColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmarEliminarCategoria(Categoria categoria) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
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

    if (confirmar == true) {
      try {
        await _categoriaService.eliminarCategoria(categoria.id!);
        _loadCategorias(); // Recargar la lista después de eliminar

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Error al eliminar la categoría';
          Color backgroundColor = Colors.red;

          if (e is ApiException) {
            final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
            errorMessage = '${errorData['message']}: ${e.message}';
            backgroundColor = errorData['color'];
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: backgroundColor,
            ),
          );
        }
      }
    }
  }
}
