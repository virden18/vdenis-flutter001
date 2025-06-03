import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_bloc.dart';
import 'package:vdenis/bloc/comentario/comentario_event.dart';
import 'package:vdenis/components/comentarios/comment_app_bar.dart';
import 'package:vdenis/components/comentarios/comment_input_form.dart';
import 'package:vdenis/components/comentarios/comment_list.dart';
import 'package:vdenis/components/comentarios/comment_search_bar.dart';

class ComentariosScreen extends StatelessWidget {
  final String noticiaId;
  final String noticiaTitulo;

  const ComentariosScreen({super.key, required this.noticiaId, required this.noticiaTitulo});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ComentarioBloc>()
        ..add(LoadComentarios(noticiaId)),
      child: _ComentariosScreenContent(
        noticiaId: noticiaId,
        noticiaTitulo: noticiaTitulo,
      ),
    );
  }
}

class _ComentariosScreenContent extends StatefulWidget {
  final String noticiaId;
  final String noticiaTitulo;

  const _ComentariosScreenContent({required this.noticiaId, required this.noticiaTitulo});

  @override
  State<_ComentariosScreenContent> createState() =>
      _ComentariosScreenContentState();
}

class _ComentariosScreenContentState extends State<_ComentariosScreenContent> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  bool _ordenAscendente = true;
  bool _isSearchVisible = false;
  String? _respondingToId;
  String? _respondingToAutor;
  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _busquedaController.clear();
        // Ya no recargamos los datos al ocultar la barra
      }
    });
  }

  void _cancelarRespuesta() {
    setState(() {
      _respondingToId = null;
      _respondingToAutor = null;
      _comentarioController.clear();
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState(); 
  }
  @override  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CommentAppBar(
        ordenAscendente: _ordenAscendente,
        onOrdenChanged: (ascendente) {
          setState(() => _ordenAscendente = ascendente);
          context.read<ComentarioBloc>().add(OrdenarComentarios(ascendente));
        },
        titulo: widget.noticiaTitulo,
        onSearchTap: _toggleSearchBar,
        isSearchVisible: _isSearchVisible,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isSearchVisible ? 56 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isSearchVisible ? 1.0 : 0.0,
                child: _isSearchVisible ? CommentSearchBar(
                  busquedaController: _busquedaController,
                  onSearch: () => _handleSearch(),
                  noticiaId: widget.noticiaId,
                ) : null,
              ),
            ),
            SizedBox(height: _isSearchVisible ? 16 : 0),
            Expanded(
              child: CommentList(
                noticiaId: widget.noticiaId,
                onResponderComentario: (comentarioId, autor) {
                  setState(() {
                    _respondingToId = comentarioId;
                    _respondingToAutor = autor;
                  });
                },
              ),
            ),
            CommentInputForm(
              noticiaId: widget.noticiaId,
              comentarioController: _comentarioController,
              respondingToId: _respondingToId,
              respondingToAutor: _respondingToAutor,
              onCancelarRespuesta: _cancelarRespuesta,
            ),
          ],
        ),
      ),
    );
  }
  void _handleSearch() {
    if (_busquedaController.text.isEmpty) {
      context.read<ComentarioBloc>().add(LoadComentarios(widget.noticiaId));
    } else {
      context.read<ComentarioBloc>().add(
        BuscarComentarios(
          _busquedaController.text,
          widget.noticiaId,
        ),
      );
    }
  }
}