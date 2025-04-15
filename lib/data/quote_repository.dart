import 'package:vdenis/domain/quote.dart';

class QuoteRepository {
  Future<List<Quote>> getQuotes() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
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
    ];
  }
}