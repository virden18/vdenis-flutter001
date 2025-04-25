import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/exceptions/api_exception.dart';
import 'package:vdenis/helpers/noticia_card_helper.dart';
import 'package:vdenis/views/presentation/categoria/categoria_screen.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();
  final List<Noticia> _noticiasList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
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
      _errorMessage = null;
    });

    try {
      final nuevasNoticias = await _noticiaService.loadMoreNoticias();

      setState(() {
        _noticiasList.clear(); // Limpiar lista existente para evitar duplicados
        _noticiasList.addAll(nuevasNoticias);
        _isLoading = false;
        _lastUpdated =
            DateTime.now(); // Actualiza la hora de última actualización
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
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
      body: Container(
        color: Colors.grey[200], 
        child: _buildBodyContent()),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? Constants.mensajeError,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
              onDelete: (noticia) => _eliminarNoticia(noticia),
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
    String selectedCategoriaId =
        noticia?.categoriaId ?? Constants.defaultCategoriaId;

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
                    categoriaId:
                        selectedCategoriaId, // Usar la categoría seleccionada
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

    Future<void> _guardarNoticia(Noticia noticia) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await _noticiaService.createNoticia(noticia);
      setState(() {
        _noticiasList.add(noticia);
        _lastUpdated = DateTime.now(); // Actualizar timestamp
        _loadNoticias();
      });
      navigator.pop();
      _showSuccessMessage(scaffoldMessenger, 'Noticia creada exitosamente');
    } catch (e) {
      _showErrorMessage(scaffoldMessenger, e);
    }
  }

  Future<void> _actualizarNoticia(Noticia noticia, String id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await _noticiaService.updateNoticia(id, noticia);
      setState(() {
        final index = _noticiasList.indexWhere((item) => item.id == noticia.id);
        if (index != -1) {
          _noticiasList[index] = noticia;
        }
        _lastUpdated = DateTime.now(); // Actualizar timestamp
        _loadNoticias();
      });
      navigator.pop();
      _showSuccessMessage(
        scaffoldMessenger,
        'Noticia actualizada exitosamente',
      );
    } catch (e) {
      _showErrorMessage(scaffoldMessenger, e);
    }
  }

  Future<void> _eliminarNoticia(Noticia noticia) async {
    try {
      // Mostrar indicador de carga
      setState(() {
        _isLoading = true;
      });

      // Eliminar la noticia
      await _noticiaService.deleteNoticia(noticia.id);

      // Actualizar la UI
      if (mounted) {
        setState(() {
          _noticiasList.removeWhere((item) => item.id == noticia.id);
          _isLoading = false;
          _lastUpdated = DateTime.now();
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Noticia eliminada exitosamente')),
        );
      }
    } catch (e) {
      // Manejar errores
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = 'Error al eliminar la noticia';

        if (e is ApiException) {
          errorMessage = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }

      // Recargar la lista para asegurar consistencia
      _loadNoticias();
    }
  }

  void _showSuccessMessage(
    ScaffoldMessengerState scaffoldMessenger,
    String message,
  ) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(
    ScaffoldMessengerState scaffoldMessenger,
    dynamic error,
  ) {
    String errorMessage = 'Error en la operación';

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
