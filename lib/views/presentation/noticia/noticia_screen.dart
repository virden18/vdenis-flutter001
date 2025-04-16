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

  List<Noticia> _noticias = [];
  bool _isLoading = false;
  int _currentPage = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadInitialNoticias();
    _scrollController.addListener(_onScroll);
    _currentPage = _noticiaService.getNoticias().length + 1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialNoticias() async {
    setState(() {
      _isLoading = true;
    });

    final noticias = _noticiaService.getNoticias();
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula un retraso de red
    setState(() {
      _noticias = noticias;
      _isLoading = false;
    });
  }

  void _loadMoreNoticias() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final newNoticias = _noticiaService.loadMoreNoticias(
      page: _currentPage,
    );
    await Future.delayed(
      const Duration(seconds: 2), // Simula un retraso de red
    ); 
    setState(() {
      _noticias.addAll(newNoticias);
      _currentPage += _pageSize;
      _isLoading = false;
    });
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
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Colors.grey[200], // Fondo de pantalla
      body:
          _isLoading && _noticias.isEmpty
              ? const Center(
                child: Text(Constants.mensajeCargando),
              ) // Mensaje mientras se cargan
              : _noticias.isEmpty
              ? const Center(
                child: Text(Constants.listaVacia),
              ) // Mensaje si la lista está vacía
              : ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _noticias.length + (_isLoading ? 1 : 0),
                separatorBuilder:
                    (context, index) => const SizedBox(
                      height: Constants.espaciadoAlto,
                    ), // Separación entre Cards
                itemBuilder: (context, index) {
                  if (index == _noticias.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final noticia = _noticias[index];
                  return NoticiaCardHelper.buildNoticiaCard(
                    noticia,
                  ); // Construcción del Card
                },
              ),
    );
  }
}
