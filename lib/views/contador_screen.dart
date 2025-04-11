
import 'package:flutter/material.dart';

class ContadorScreen extends StatefulWidget {
  const ContadorScreen({super.key});
  final String title = 'Contador';

  @override
  State<ContadorScreen> createState() => _ContadorScreenState();
}

class _ContadorScreenState extends State<ContadorScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _restartCounter() {
    setState(() {
      _counter = 0;
    });
  }

  String _message() {
    if (_counter > 0) {
      return 'El contador es positivo: $_counter';
    } else if (_counter < 0) {
      return 'El contador es negativo: $_counter';
    } else {
      return 'El contador es cero: $_counter';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _counter > 0 
                    ? Colors.green 
                    : (_counter < 0 ? Colors.red : Colors.black),
              ),
            ),
          ],
        ),
      ),
  
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            heroTag: 'restart',
            onPressed: _restartCounter,
            tooltip: 'Restart',
            child: const Icon(Icons.refresh))
        ],
      ),
    );
  }
}

