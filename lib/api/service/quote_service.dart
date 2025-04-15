import 'package:vdenis/data/quote_repository.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  Future<List<Quote>> fetchQuotes() async {
    return await _repository.getQuotes();
  }
}