import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TasksScreen(),
    );
  }
}

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Lista de tareas de ejemplo
  List<String> tasks = [
    'Comprar leche',
    'Hacer ejercicio',
    'Llamar a mamá',
    'Estudiar Flutter',
    'Preparar presentación',
  ];

  void _editTask(int index) {
    final TextEditingController taskController =
        TextEditingController(text: tasks[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(labelText: 'Título de la tarea'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tasks[index] = taskController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tasks.removeAt(index); // Elimina la tarea de la lista
              });
              Navigator.pop(context); // Cierra el diálogo
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tareas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(tasks[index]),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      _editTask(index); // Llama al método para editar la tarea
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Muestra un diálogo al presionar el FAB
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Nueva tarea'),
              content: const Text('Aquí iría el formulario para agregar una nueva tarea'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
