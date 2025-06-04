import 'package:flutter/material.dart';
import 'package:vdenis/api/service/quote_service.dart';
import 'package:vdenis/domain/quote.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes = [];
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  static const double spacingHeight = 10; 

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadQuotes();
      }
    });
  }

  Future<void> _loadInitialQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allQuotes = await _quoteService.getAllQuotes();
      setState(() {
        _quotes = allQuotes;
        _pageNumber = 1;
        _hasMore = allQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _pageNumber, pageSize: 5);
      setState(() {
        _quotes.addAll(newQuotes);
        _pageNumber++;
        _hasMore = newQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
        );
      }     
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Volver',
        ),
        title: const Text(CotizacionConstantes.titleApp),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _quotes.isEmpty && _isLoading
          ? const Center(
              child: Text(CotizacionConstantes.loadingMessage),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _quotes.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _quotes.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final quote = _quotes[index];
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quote.companyName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8.0),
                              Text('Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
                              Text(
                                'Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: quote.changePercentage >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                              Text(
                                'Última actualización: ${_formatDate(quote.lastUpdated)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: spacingHeight),
                  ],
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}