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
  // Lista de tareas
  final List<Map<String, dynamic>> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('No hay tareas. Agrega una nueva.'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(task['titulo']),
                    subtitle: Text(
                        '${task['descripcion']} - ${task['fecha'] ?? 'Sin fecha'}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Muestra un snackbar al tocar una tarea
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Seleccionaste: ${task['titulo']}'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showTaskModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Tarea'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(selectedDate == null
    ? 'Seleccionar fecha'
    : 'Fecha: ${selectedDate!.toLocal()}'.split(' ')[0]),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text('Elegir Fecha'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'titulo': titleController.text,
                      'descripcion': descriptionController.text,
                      'fecha': selectedDate != null
    ? '${selectedDate!.toLocal().toString().split(' ')[0]}'
    : 'Sin fecha',
                    });
                  });
                  Navigator.of(context).pop();
                } else {
                  // Mostrar un mensaje de error si los campos están vacíos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}