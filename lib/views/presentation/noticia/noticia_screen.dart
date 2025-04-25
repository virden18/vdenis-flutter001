import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vdenis/api/service/noticia_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/noticia_card_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _loadNoticias();
    _scrollController.addListener(_onScroll);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Aquí puedes agregar lógica adicional si es necesario
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
        _noticiasList.addAll(nuevasNoticias);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;

        if (e is NoticiaServiceException) {
          _errorMessage = e.userFriendlyMessage;
        } else {
          _errorMessage = 'Error inesperado. Por favor, intenta más tarde.';
        }
      });
    }
  }

  void _loadMoreNoticias() {
    if (!_isLoading && !_hasError) {
      _loadNoticias();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreNoticias();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.tituloAppNoticias),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.grey[200],
        child: _buildBodyContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNoticiaForm,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateNoticiaForm() {
    final formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController fuenteController = TextEditingController();
    final TextEditingController urlImagenController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: urlImagenController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final nuevaNoticia = Noticia(
                        id: DateTime.now().toString(),
                        titulo: tituloController.text,
                        descripcion: descripcionController.text,
                        fuente: fuenteController.text,
                        publicadaEl: DateTime.now(),
                        urlImagen: urlImagenController.text.isNotEmpty
                            ? urlImagenController.text
                            : Constants.urlImagen,
                      );

                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      try {
                        // Enviar la nueva noticia al servidor y recibir la versión con ID correcto
                        final createdNoticia = await _noticiaService.createNoticia(nuevaNoticia);

                        setState(() {
                          
                          _noticiasList.add(createdNoticia);
                      
                        });

                        navigator.pop();

                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Noticia creada exitosamente')),
                        );
                      } catch (e) {
                        if (e is NoticiaServiceException) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text(e.userFriendlyMessage)),
                          );
                        } else {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Error al crear la noticia')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Crear Noticia'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditNoticiaForm(Noticia noticia) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController(text: noticia.titulo);
    final TextEditingController descripcionController = TextEditingController(text: noticia.descripcion);
    final TextEditingController fuenteController = TextEditingController(text: noticia.fuente);
    final TextEditingController urlImagenController = TextEditingController(text: noticia.urlImagen);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Editar Noticia', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: urlImagenController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final noticiaActualizada = Noticia(
                            id: noticia.id,
                            titulo: tituloController.text,
                            descripcion: descripcionController.text,
                            fuente: fuenteController.text,
                            publicadaEl: noticia.publicadaEl,
                            urlImagen: urlImagenController.text.isNotEmpty
                                ? urlImagenController.text
                                : Constants.urlImagen,
                          );

                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);

                          try {
                            await _noticiaService.updateNoticia(noticia.id, noticiaActualizada);

                            setState(() {
                              final index = _noticiasList.indexWhere((item) => item.id == noticia.id);
                              if (index != -1) {
                                _noticiasList[index] = noticiaActualizada;
                              }
                              didUpdateWidget(const NoticiaScreen());
                            });

                            navigator.pop();

                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Noticia actualizada exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            String errorMessage = 'Error al actualizar la noticia';

                            if (e is NoticiaServiceException) {
                              errorMessage = e.userFriendlyMessage;
                            }

                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Agregar un método para mostrar un snackbar de deshacer la eliminación
  void _showUndoSnackbar(Noticia noticia, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Noticia eliminada'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              // Reinsertar la noticia en su posición original
              if (index < _noticiasList.length) {
                _noticiasList.insert(index, noticia);
              } else {
                _noticiasList.add(noticia);
              }
            });
          },
        ),
      ),
    );
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
          setState(() {
            _noticiasList.clear();
          });
          await _loadNoticias();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _noticiasList.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _noticiasList.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final noticia = _noticiasList[index];
            return Dismissible(
              key: Key(noticia.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmar eliminación"),
                      content: const Text("¿Estás seguro de que deseas eliminar esta noticia?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Eliminar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) async {
                final deletedNoticia = noticia;
                final position = index;

                setState(() {
                  _noticiasList.removeAt(index);
                });
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  await _noticiaService.deleteNoticia(deletedNoticia.id);

                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Noticia eliminada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      if (position < _noticiasList.length) {
                        _noticiasList.insert(position, deletedNoticia);
                      } else {
                        _noticiasList.add(deletedNoticia);
                      }
                    });

                    String errorMessage = 'Error al eliminar la noticia';
                    if (e is NoticiaServiceException) {
                      errorMessage = e.userFriendlyMessage;
                    }

                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }

                _showUndoSnackbar(deletedNoticia, position);
              },
              child: NoticiaCardHelper.buildNoticiaCard(
                noticia,
                onTap: (noticia) => _showEditNoticiaForm(noticia),
              ),
            );
          },
        ),
      );
    }
  }
}