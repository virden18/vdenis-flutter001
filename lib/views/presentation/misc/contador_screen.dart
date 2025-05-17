import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/contador/contador_bloc.dart';
import 'package:vdenis/bloc/contador/contador_event.dart';
import 'package:vdenis/bloc/contador/contador_state.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<ContadorBloc, ContadorState>(
              builder: (context, state) {
                return Text(
                  _getMessage(state.contador),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _getColor(state.contador),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<ContadorBloc>().add(Incrementar());
            },
            tooltip: 'Sumar',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            onPressed: () {
              context.read<ContadorBloc>().add(Decrementar());
            },
            tooltip: 'Restar',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16), // Espaciado entre los botones
          FloatingActionButton(
            onPressed: () {
              context.read<ContadorBloc>().add(Resetear());
            },
            tooltip: 'Resetear',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Color _getColor(int counter) {
    if (counter > 0) {
      return Colors.green;
    } else if (counter < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  String _getMessage(int counter) {
    if (counter > 0) {
      return 'El contador es positivo: $counter';
    } else if (counter < 0) {
      return 'El contador es negativo: $counter';
    } else {
      return 'El contador es cero: $counter';
    }
  }

}
