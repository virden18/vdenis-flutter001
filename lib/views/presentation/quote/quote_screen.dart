import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/api/service/quote_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/quote.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';

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
    if (!mounted) return; // Verificación inicial de mounted
    
    setState(() {
      _isLoading = true; // Marca como cargando
      _error = null; // Resetea errores previos
    });

    try {
      final newQuotes = await _quoteService.getPaginacion(
        _currentPage,
        QuoteConstants.pageSize,
      );
      
      if (!mounted) return; // Verificación después de la operación async
      
      setState(() {
        _quoteService.updateQuotes(newQuotes); // Añade las nuevas cotizaciones
        _currentPage +=
            newQuotes
                .length; // Incrementa el número de página para la próxima carga
        _isLoading = false; // Marca como carga finalizada
      });
    } catch (e) {
      if (!mounted) return; // Verificación después de la operación async en caso de error
      
      setState(() {
        _isLoading = false; // Marca como carga finalizada (con error)
        _error = "Error al cargar datos: ${e.toString()}"; // Guarda el error
      });
    }
  }

  // Función para cargar las siguientes páginas de cotizaciones
  Future<void> _fetchMoreQuotes() async {
    if (!mounted) return; // Verificación inicial de mounted
    
    setState(() {
      _isFetchingMore = true; // Marca como cargando más datos
    });

    try {
      // Llama al servicio para obtener la siguiente página
      final newQuotes = await _quoteService.getPaginacion(
        _currentPage,
        QuoteConstants.pageSize,
      );
      
      if (!mounted) return; // Verificación después de la operación async
      
      setState(() {
        _quoteService.updateQuotes(
          newQuotes,
        ); // Añade las nuevas cotizaciones a la lista existente
        _currentPage =
            _quoteService.getLength(); // Incrementa el número de página
        _isFetchingMore = false; // Marca como carga finalizada
        _quotes = _quoteService.getQuotes();
      });
    } catch (e) {
      if (!mounted) return; // Verificación después de la operación async en caso de error
      
      setState(() {
        _isFetchingMore = false; 
        //print("Error fetching more quotes: $e"); // Imprime el error en consola
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(QuoteConstants.titleApp),
        backgroundColor: Colors.blueGrey,
      ),
      body:
          _buildBody(),
          backgroundColor: Colors.grey[200], // Llama a una función separada para construir el cuerpo
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
          final bool isPositiveChange = quote.changePercentage >= 0;
          final Color changeColor =
              isPositiveChange ? Colors.green : Colors.red;
          final DateFormat formatter = DateFormat(AppConstantes.formatoFecha);
          final String formattedDate = formatter.format(quote.lastUpdated);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  CommonWidgetsHelper.buildSpacing(height: 4),
                  Text(
                    'Precio: \$${quote.stockPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  CommonWidgetsHelper.buildSpacing(height: 4),
                  Text(
                    'Cambio: ${quote.changePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: changeColor, // Apply dynamic color
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  CommonWidgetsHelper.buildSpacing(height: 8),
                  Text(
                    'Ultima actualización: $formattedDate', // Display formatted date
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600], // Softer color for the date
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
