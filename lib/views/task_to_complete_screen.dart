import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';

class TaskToCompleteScreen extends StatelessWidget {
  final Task task;

  const TaskToCompleteScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              PASOS_TITULO,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...(task.pasos?.map((paso) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('- $paso'),
                )) ?? []),
            const SizedBox(height: 16),
            Text(
              'Descripción:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 16),
            Text(
              'Fecha límite:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(task.fechaLimite.toLocal().toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }
}