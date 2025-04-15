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
  late Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _quotesFuture = _quoteService.fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(titleApp)),
      body: FutureBuilder<List<Quote>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text(loadingMessage));
          }
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          final quotes = snapshot.data ?? [];
          
          return quotes.isEmpty
              ? const Center(child: Text(emptyList))
              : ListView.builder(
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quotes[index];
                    return ListTile(
                      title: Text(quote.companyName),
                      subtitle: Text(
                          'Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
                      trailing: Text(
                        '${quote.changePercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: quote.changePercentage >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}