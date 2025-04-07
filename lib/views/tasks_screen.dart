import 'package:flutter/material.dart';
import 'package:vdenis/api/service/task_service.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';

class TasksScreen extends StatefulWidget {
  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final TaskService _taskService = TaskService(); // Instancia del servicio
  late List<Task> tasks; // Lista de tareas

  @override
  void initState() {
    super.initState();
    tasks = []; // Carga inicial de tareas
  }

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
                    subtitle: Text(TASK_TYPE_LABEL + task.type),
                    trailing: task.type == TASK_TYPE_URGENT
                        ? const Icon(
                            Icons.warning,
                            color: Colors.red,
                          )
                        : task.type == TASK_TYPE_NORMAL
                            ? const Icon(
                                Icons.task,
                                color: Colors.blue,
                              )
                            : const SizedBox(),
                    onTap: () {
                      _showTaskOptionsModal(context, task, index);
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
                  final newTask = Task(
                                      title: titleController.text,
                                      type: typeController.text,
                                    );
                  _taskService.createTask(newTask); // Agrega la tarea al servicio
                  setState(() {
                    tasks = _taskService.getTasks(); // Actualiza la lista de tareas
                  });
                  Navigator.of(context).pop();
                } else {
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

  void _showTaskOptionsModal(BuildContext context, Task task, int index) {
    final TextEditingController titleController =
        TextEditingController(text: task.title);
    final TextEditingController typeController =
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
                final updatedTask = Task(
                  title: titleController.text,
                );
                _taskService.updateTask(index, updatedTask); // Actualiza la tarea en el servicio
                setState(() {
                  tasks = _taskService.getTasks(); // Actualiza la lista de tareas
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                _taskService.deleteTask(index); // Elimina la tarea del servicio
                setState(() {
                  tasks = _taskService.getTasks(); // Actualiza la lista de tareas
                });
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}