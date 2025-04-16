import 'package:flutter/material.dart';
import 'package:vdenis/api/service/quote_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes =
      []; // Lista para almacenar todas las cotizaciones cargadas
  int _currentPage = 1; // Página actual
  bool _isLoading = false; // Para el estado de carga inicial
  bool _isFetchingMore = false; // Para el estado de carga de más elementos
  String? _error; // Para almacenar mensajes de error

  @override
  void initState() {
    super.initState();
    _quotes = _quoteService.getQuotes();
    _fetchInitialQuotes(); // Carga inicial de datos
    _scrollController.addListener(
      _onScroll,
    ); // Añade el listener para el scroll
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Limpia el listener
    _scrollController.dispose(); // Libera el controlador
    super.dispose();
  }

   void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchMoreQuotes(); // Carga más tareas al llegar al final
    }
  }

  // Función para la carga inicial de cotizaciones
  Future<void> _fetchInitialQuotes() async {
    setState(() {
      _isLoading = true; // Marca como cargando
      _error = null; // Resetea errores previos
    });

    try {
      final newQuotes = await _quoteService.getPaginacion(_currentPage, Constants.pageSize);
      setState(() {
        _quoteService.updateQuotes(newQuotes); // Añade las nuevas cotizaciones
        _currentPage += newQuotes.length; // Incrementa el número de página para la próxima carga
        _isLoading = false; // Marca como carga finalizada
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Marca como carga finalizada (con error)
        _error = "Error al cargar datos: ${e.toString()}"; // Guarda el error
      });
    }
  }

  // Función para cargar las siguientes páginas de cotizaciones
  Future<void> _fetchMoreQuotes() async {
    setState(() {
      _isFetchingMore = true; // Marca como cargando más datos
    });

    try {
      // Llama al servicio para obtener la siguiente página
      final newQuotes = await _quoteService.getPaginacion(_currentPage, Constants.pageSize);
      setState(() {
        _quoteService.updateQuotes(newQuotes);// Añade las nuevas cotizaciones a la lista existente
        _currentPage = _quoteService.getLength(); // Incrementa el número de página
        _isFetchingMore = false; // Marca como carga finalizada
        _quotes = _quoteService.getQuotes();
      });
    } catch (e) {
      setState(() {
        _isFetchingMore = false; // Marca como carga finalizada (con error)
        // Podrías mostrar un Snackbar o un mensaje diferente para errores al cargar más
        // _error = "Error al cargar más datos: ${e.toString()}";
        print("Error fetching more quotes: $e"); // Imprime el error en consola
        // Opcionalmente, podrías intentar de nuevo o mostrar un botón para reintentar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Constants.titleApp}: ${_quoteService.getLength()}' ),
        backgroundColor: Colors.blueGrey,),
      body:
          _buildBody(), // Llama a una función separada para construir el cuerpo
    );
  }

  // Widget para construir el cuerpo de la pantalla
  Widget _buildBody() {
    if (_isLoading && _quotes.isEmpty) {
      // Muestra indicador de carga solo en la carga inicial
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null && _quotes.isEmpty) {
      // Muestra error solo si no hay datos cargados previamente
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchInitialQuotes, // Botón para reintentar
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      // Muestra la lista
      return ListView.builder(
        controller: _scrollController,
        itemCount: _quotes.length + 1,
        itemBuilder: (context, index) {
          if (index == _quotes.length) {
            return _isFetchingMore
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                : const SizedBox.shrink();
          }
          
          final quote = _quotes[index];
          return ListTile(
            title: Text(quote.companyName),
            subtitle: Text('Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
            trailing: Text(
              '${quote.changePercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: quote.changePercentage >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }
  }
}
