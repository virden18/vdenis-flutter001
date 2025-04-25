import 'package:flutter/material.dart';
import 'package:vdenis/api/service/categoria_service.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  CategoriaScreenState createState() => CategoriaScreenState();
}

class CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
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
      setState(() {
        categorias = fetchedCategorias;
        isLoading = false;
      });
    } catch (e) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }

  Future<void> _agregarCategoria() async {
    final nuevaCategoriaData = await _mostrarDialogCategoria(context);
    if (nuevaCategoriaData != null) {
      try {
        final nuevaCategoria = Categoria(
          id: '', // El ID será generado por la API
          nombre: nuevaCategoriaData['nombre'],
          descripcion: nuevaCategoriaData['descripcion'] ?? '', // Usar valor predeterminado si es null
          imagenUrl: nuevaCategoriaData['imagenUrl'] ?? '', // Usar valor predeterminado si es null
        );

        await _categoriaService.crearCategoria(nuevaCategoria); // Llama al servicio
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
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
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(categoria.descripcion),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'ID: ${categoria.id}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: categoria.imagenUrl.isNotEmpty
                          ? Image.network(
                              categoria.imagenUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Error cargando imagen: $error');
                                return const Icon(Icons.category, color: Colors.grey);
                              },
                            )
                          : const Icon(Icons.category, color: Color.fromARGB(255, 48, 46, 46)),
                      ),
                      isThreeLine: categoria.descripcion.isNotEmpty,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
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
    );
  }
}
