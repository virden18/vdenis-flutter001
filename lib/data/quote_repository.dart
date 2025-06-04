import 'dart:async';
import 'dart:math';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteRepository {
  final List<Quote> _quotes = [
    Quote(companyName: 'Apple', stockPrice: 150.25, changePercentage: 2.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Microsoft', stockPrice: 280.50, changePercentage: -1.2, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Google', stockPrice: 2700.00, changePercentage: 0.8, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Amazon', stockPrice: 3400.75, changePercentage: -0.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Tesla', stockPrice: 700.10, changePercentage: 3.0, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Apple', stockPrice: 150.25, changePercentage: 2.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Microsoft', stockPrice: 280.50, changePercentage: -1.2, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Google', stockPrice: 2700.00, changePercentage: 0.8, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Amazon', stockPrice: 3400.75, changePercentage: -0.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Tesla', stockPrice: 700.10, changePercentage: 3.0, lastUpdated: DateTime.now(),),
  ];

  Future<List<Quote>> fetchAllQuotes() async {
    await Future.delayed(const Duration(seconds: 1));
    return _quotes;
  }

  Future<Quote> fetchRandomQuote() async {
    await Future.delayed(const Duration(seconds: 1));
    final randomIndex = Random().nextInt(_quotes.length); 
    return _quotes[randomIndex];
  }

  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = CotizacionConstantes.pageSize,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Quote> randomQuotes = List.generate(pageSize, (index) {
      return Quote(
        companyName: 'Empresa ${(pageNumber - 1) * pageSize + index + 1}',
        stockPrice: Random().nextDouble() * 5000,
        changePercentage: Random().nextDouble() * 200 - 100,
        lastUpdated: DateTime.now(),
      );
    });

    return randomQuotes;
  }
}