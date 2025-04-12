import 'package:flutter/material.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de cotizaciones ficticias de monedas en relación al guaraní
    final List<Map<String, String>> quotes = [
      {'symbol': 'USD', 'price': '7,200 PYG'}, // Dólar estadounidense
      {'symbol': 'EUR', 'price': '8,000 PYG'}, // Euro
      {'symbol': 'BRL', 'price': '1,400 PYG'}, // Real brasileño
      {'symbol': 'ARS', 'price': '50 PYG'},    // Peso argentino
      {'symbol': 'CLP', 'price': '10 PYG'},    // Peso chileno
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizaciones de Monedas'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(quote['symbol']!),
            subtitle: Text('Precio: ${quote['price']}'),
          );
        },
      ),
    );
  }
}