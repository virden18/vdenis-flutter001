import 'dart:math';

import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/quote.dart';

class QuoteRepository {
  final List<Quote> _quotes;
  
  QuoteRepository() : _quotes = [] {
    _quotes.addAll([
      Quote(
        companyName: 'Apple',
        stockPrice: 150.25,
        changePercentage: 2.5,
        lastUpdated: DateTime(2025, 2, 23),
      ),
      Quote(
        companyName: 'Google',
        stockPrice: 2750.30,
        changePercentage: -1.2,
        lastUpdated: DateTime(2025, 2, 25),
      ),
      Quote(
        companyName: 'Microsoft',
        stockPrice: 300.45,
        changePercentage: 0.8,
        lastUpdated: DateTime(2025, 3, 12),
      ),
      Quote(
        companyName: 'Amazon',
        stockPrice: 3400.75,
        changePercentage: 3.1,
        lastUpdated: DateTime(2025, 3, 15),
      ),
      Quote(
        companyName: 'Tesla',
        stockPrice: 700.60,
        changePercentage: -0.5,
        lastUpdated: DateTime(2025, 3, 17),
      ),
      Quote(
        companyName: 'Netflix',
        stockPrice: 150.25,
        changePercentage: 2.5,
        lastUpdated: DateTime(2025, 4, 10),
      ),
      Quote(
        companyName: 'Meta',
        stockPrice: 2750.30,
        changePercentage: -1.2,
        lastUpdated: DateTime(2025, 1, 2),
      ),
      Quote(
        companyName: 'Intel',
        stockPrice: 300.45,
        changePercentage: 0.8,
        lastUpdated: DateTime(2025, 3, 13),
      ),
      Quote(
        companyName: 'AMD',
        stockPrice: 3400.75,
        changePercentage: 3.1,
        lastUpdated: DateTime(2025, 3, 16),
      ),
      Quote(
        companyName: 'Nvidia',
        stockPrice: 700.60,
        changePercentage: -0.5,
        lastUpdated: DateTime(2025, 2, 28),
      ),
    ]);
  }
  
  List<Quote> getQuotes() {
    return _quotes;
  }

  final _random = Random();

  Future<List<Quote>> getQuotesPag(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Quote> generatedQuotes = [];
    int startIndex = page;

    for (int i = 0; i < pageSize; i++) {
      String companyName = '${Constants.nombreEmpresa} $startIndex';
      startIndex++;


      // Genera datos aleatorios para la cotización
      double stockPrice = 50.0 + _random.nextDouble() * 3000.0; // Precio entre 50 y 3050
      double changePercentage = -5.0 + (_random.nextDouble() * 10.0) ; // Cambio entre -5.0% y +5.0%
      DateTime lastUpdated = DateTime.now().subtract(Duration(days: _random.nextInt(30))); // Fecha en los últimos 30 días

      generatedQuotes.add(
        Quote(
          companyName: companyName,
          stockPrice: double.parse(stockPrice.toStringAsFixed(2)), // Redondea a 2 decimales
          changePercentage: double.parse(changePercentage.toStringAsFixed(2)), // Redondea a 2 decimales
          lastUpdated: lastUpdated,
        ),
      );
    }
    return generatedQuotes;
  }

  void updateQuotes(List<Quote> quotes) {
    for (Quote quote in quotes) {
      _quotes.add(quote);
    }   
  }

  int getLength() {
    return _quotes.length;
  }
}