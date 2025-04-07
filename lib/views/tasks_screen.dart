import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';

class TasksScreen extends StatefulWidget {
  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  // Lista de tareas
  List<Task> tasks = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TITLE_APPBAR),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(EMPTY_LIST, style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.type),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      _showTaskOptionsModal(context, index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_task',
        onPressed: () {
          _showTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTaskModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(
                      title: titleController.text,
                    ));
                  });
                  Navigator.of(context).pop();
                } else {
                  // Mostrar un mensaje de error si los campos están vacíos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskOptionsModal(BuildContext context, int index) {
    final task = tasks[index];
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController descriptionController =
        TextEditingController(text: task.type);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks[index] = Task(
                    title: titleController.text,
                    type: descriptionController.text,
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index); // Elimina la tarea de la lista
                });
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}