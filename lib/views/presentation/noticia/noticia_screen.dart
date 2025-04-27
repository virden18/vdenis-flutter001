import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vdenis/data/categoria_repository.dart';
import 'package:vdenis/data/noticia_repository.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/categoria.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/error_helper.dart';
import 'package:vdenis/helpers/message_helper.dart';
import 'package:vdenis/helpers/noticia_card_helper.dart';
import 'package:vdenis/views/presentation/categoria/categoria_screen.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> _noticiasList = [];
  final Map<String, String> _categoriasCache = {};

  bool _isLoading = false;
  bool _hasError = false;
  int _statusCode = 0;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _cargarCategorias(); // Cargar categorías al iniciar
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNoticias() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final nuevasNoticias = await _noticiaRepository.loadMoreNoticias();

      if (mounted) {
        setState(() {
          _noticiasList
              .clear(); // Limpiar lista existente para evitar duplicados
          _noticiasList.addAll(nuevasNoticias);
          _isLoading = false;
          _lastUpdated =
              DateTime.now(); // Actualiza la hora de última actualización
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _statusCode = (e is ApiException ? e.statusCode : 0)!;
        });

        if (e is ApiException) {
          MessageHelper.showSnackBar(
            context,
            e.message,
            statusCode: e.statusCode,
          );
        } else {
          MessageHelper.showSnackBar(
            context,
            ErrorHelper.getServiceErrorMessage(e.toString()),
          );
        }
      }
    }
  }

  // Añadir este método a tu clase NoticiaScreenState
  Future<void> _cargarCategorias() async {
    try {
      final repository = CategoriaRepository();
      final categorias = await repository.getCategorias();
      
      // Guardar las categorías en caché para uso posterior
      for (final categoria in categorias) {
        _categoriasCache[categoria.id!] = categoria.nombre;
      }
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.tituloAppNoticias),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categorías',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriaScreen(),
                ),
              );
            },
          ),
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Actualizado:', style: TextStyle(fontSize: 10)),
                    Text(
                      _formatLastUpdated(_lastUpdated!),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Container(color: Colors.grey[200], child: _buildBodyContent()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoticiaForm(),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Método para formatear la fecha
  String _formatLastUpdated(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildBodyContent() {
    if (_isLoading && _noticiasList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(Constants.mensajeCargando),
          ],
        ),
      );
    } else if (_hasError) {
      final errorMessage = ErrorHelper.getErrorMessageAndColor(_statusCode);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage['message'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _noticiasList.clear();
                });
                _loadNoticias();
              },
              child: const Text(
                'Reintentar',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      );
    } else if (_noticiasList.isEmpty) {
      return const Center(
        child: Text(
          Constants.listaVaciaNoticias,
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await _loadNoticias();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _noticiasList.length,
          itemBuilder: (context, index) {
            final noticia = _noticiasList[index];
            return NoticiaCardHelper.buildNoticiaCard(
              noticia,
              onEdit: (noticia) {
                _showNoticiaForm(noticia: noticia);
              },
              onDelete: (noticia) => _confirmarEliminarNoticia(noticia),
              categoriaNombre: _categoriasCache[noticia.categoriaId] ?? 'Desconocida',
            );
          },
        ),
      );
    }
  }

  void _showNoticiaForm({Noticia? noticia}) {
    // Es edición si noticia no es null
    final bool isEditing = noticia != null;
    final String title = isEditing ? 'Editar Noticia' : 'Crear Noticia';
    final String buttonText = isEditing ? 'Actualizar' : 'Crear';
    String id = '';
    if (isEditing) {
      id = noticia.id;
    }

    // Valor por defecto para categoría - usar existente o defaultCategoriaId
    String selectedCategoriaId = noticia?.categoriaId ?? Constants.defaultCategoriaId;

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

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
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
                    
                    // Agregar selector de categoría
                    FutureBuilder<List<Categoria>>(
                      // Obtener categorías del repositorio
                      future: _getCategorias(),
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
                        
                        // Si no hay categorías, mostrar mensaje
                        if (categorias.isEmpty) {
                          return const Text(
                            'No hay categorías disponibles',
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                        
                        // Crear lista de items para el dropdown
                        final items = [
                          // Agregar la opción "Sin categoría"
                          const DropdownMenuItem<String>(
                            value: Constants.defaultCategoriaId,
                            child: Text('Sin categoría'),
                          ),
                          // Agregar las categorías disponibles
                          ...categorias.map((categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria.id,
                              child: Text(categoria.nombre),
                            );
                          }),
                        ];
                        
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            border: OutlineInputBorder(),
                          ),
                          value: items.any((item) => item.value == selectedCategoriaId) 
                              ? selectedCategoriaId 
                              : Constants.defaultCategoriaId,
                          items: items,
                          onChanged: (value) {
                            selectedCategoriaId = value ?? Constants.defaultCategoriaId;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final Noticia newNoticia = Noticia(
                      id: '',
                      titulo: tituloController.text,
                      descripcion: descripcionController.text,
                      fuente: fuenteController.text,
                      publicadaEl: noticia?.publicadaEl ?? DateTime.now(),
                      urlImagen:
                          urlImagenController.text.isNotEmpty
                              ? urlImagenController.text
                              : Constants.urlImagen,
                      categoriaId: selectedCategoriaId, // Usar la categoría seleccionada
                    );

                    if (isEditing) {
                      _actualizarNoticia(newNoticia, id);
                    } else {
                      _guardarNoticia(newNoticia);
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
  }

  Future<void> _guardarNoticia(Noticia noticia) async {
    try {
      if (mounted) {
        // Verificar mounted antes de actualizar estado
        setState(() {
          _isLoading = true;
        });
      }

      await _noticiaRepository.createNoticia(noticia);
      _loadNoticias(); // Recargar la lista

      if (mounted) {
        Navigator.pop(context); // Cerrar el diálogo
        MessageHelper.showSnackBar(
          context,
          Constants.successCreated,
          isSuccess: true,
        );
      }
    } catch (e) {
      if (mounted) {
        // Verificar mounted antes de actualizar estado
        setState(() {
          _isLoading = false;
        });

        if (e is ApiException) {
          if (mounted) {
            MessageHelper.showSnackBar(
              context,
              e.message,
              statusCode: e.statusCode,
            );
          }
        } else {
          MessageHelper.showSnackBar(
            context,
            ErrorHelper.getServiceErrorMessage(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _actualizarNoticia(Noticia noticia, String id) async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await _noticiaRepository.updateNoticia(id, noticia);
      _loadNoticias();

      if (mounted) {
        Navigator.pop(context); // Cerrar el diálogo
        MessageHelper.showSnackBar(
          context,
          Constants.successUpdated,
          isSuccess: true,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (e is ApiException) {
          MessageHelper.showSnackBar(
            context,
            e.message,
            statusCode: e.statusCode,
          );
        } else {
          MessageHelper.showSnackBar(
            context,
            ErrorHelper.getServiceErrorMessage(e.toString()),
          );
        }
      }
    }
  }

  // Mejorar el método _confirmarEliminarNoticia
  Future<void> _confirmarEliminarNoticia(Noticia noticia) async {
    if (!mounted) return; // Verificar mounted antes de mostrar diálogo

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
                child: const Text('Cancelarr'),
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
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        await _noticiaRepository.deleteNoticia(noticia.id);
        _loadNoticias();

        if (mounted) {
          MessageHelper.showSnackBar(
            context,
            Constants.successDeleted,
            isSuccess: true,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (e is ApiException) {
            MessageHelper.showSnackBar(
              context,
              e.message,
              statusCode: e.statusCode,
            );
          } else {
            MessageHelper.showSnackBar(
              context,
              ErrorHelper.getServiceErrorMessage(e.toString()),
            );
          }
        }
      }
    }
  }

  // Método para obtener las categorías del repositorio
  Future<List<Categoria>> _getCategorias() async {
    try {
      // Necesitamos importar e instanciar el CategoriaRepository
      final categoriaRepository = CategoriaRepository();
      return await categoriaRepository.getCategorias();
    } catch (e) {
      // En caso de error, devolver una lista vacía
      debugPrint('Error al cargar categorías: $e');
      return [];
    }
  }
}
