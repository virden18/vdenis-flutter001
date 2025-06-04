import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/data/quote_repository.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  Future<List<Quote>> getAllQuotes() {
    return _repository.fetchAllQuotes();
  }

  Future<Quote> getRandomQuote() {
    return _repository.fetchRandomQuote();
  }

  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = CotizacionConstantes.pageSize
  }) async {
    if (pageNumber < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1.');
    }
    if (pageSize <= 0) {
      throw Exception('El tamaño de página debe ser mayor que 0.');
    }

    final quotes = await _repository.getPaginatedQuotes(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    for (final quote in quotes) {
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        throw Exception('El porcentaje de cambio debe estar entre -100 y 100.');
      }
    }

    final filteredQuotes = quotes.where((quote) => quote.stockPrice > 0).toList();

    filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));

    await Future.delayed(const Duration(seconds: 2));

    return filteredQuotes;
  }
}