import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/data/quote_repository.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  List<Quote> getQuotes() {
    return _repository.getQuotes();
  }

  Future<List<Quote>> getPaginacion(int page, int pageSize) async {
    if (page < 1) {
      throw ArgumentError(
        'El número de página debe ser mayor o igual a 1.',
        'page',
      );
    }
    if (pageSize <= 0) {
      throw ArgumentError(
        'El tamaño de página debe ser mayor que 0.',
        'pageSize',
      );
    }

    final quotes = await _repository.getQuotesPag(page, pageSize);

    List<Quote> validQuotes = [];
    for (Quote quote in quotes) {
      if (quote.changePercentage < -100 && quote.changePercentage > 100) {
        throw ArgumentError('El change percentage no puede ser menor a -100 o mayor a 100');
      } else if (quote.stockPrice < 0){
        throw ArgumentError('El stock price debe ser mayor a cero');
      } else {
        validQuotes.add(quote);
      }
    }

    validQuotes.sort((a, b) => a.stockPrice.compareTo(b.stockPrice));  
    return validQuotes;
  }

  void updateQuotes(List<Quote> quotes) {
    _repository.updateQuotes(quotes);
  }

  int getLength() {
    return _repository.getLength();
  }
}