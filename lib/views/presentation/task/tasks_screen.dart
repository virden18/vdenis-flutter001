import 'package:flutter/material.dart';
import 'package:vdenis/api/service/task_service.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';
import 'package:vdenis/components/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final TaskService _taskService = TaskService();
  final ScrollController _scrollController = ScrollController();// Instancia del servicio de asistente
  late List<Task> tasks;
  late int _nextTaskId; // ID inicial para nuevas tareas
  bool isLoading = false; // Variable para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    tasks = _taskService.getTasks(); // Obtiene la lista de tareas
    _scrollController.addListener(_onScroll); // Carga inicial de tareas
    _nextTaskId = _taskService.getTasks().length + 1; // Inicializa el ID inicial para nuevas tareas 
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreTasks(); // Carga más tareas al llegar al final
    }
  }

  void _loadMoreTasks() async {
    setState(() {
      isLoading = true; // Cambia el estado a cargando
    });

    await Future.delayed(const Duration(seconds: 1));

    final newTasks = _taskService.loadMoreTasks(_nextTaskId, 10); // Carga más tareas

    setState(() {
      tasks.addAll(newTasks);
      _nextTaskId += newTasks.length; // Actualiza el ID inicial para nuevas tareas
      isLoading = false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Elimina la tarea de la lista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('$tituloAppBar: ${_taskService.getCantidadTareas()}'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(listaVacia, style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              controller: _scrollController, // Asigna el controlador
              itemCount: tasks.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return buildTaskCard(
                  tasks,
                  tasks[index],
                  context,
                  index,
                  onEdit: (taskIndex) {
                    _showTaskModal(index: taskIndex); // Muestra el modal para editar la tarea
                  },
                  onDelete: (taskIndex) {
                    _deleteTask(taskIndex); // Llama a la función para eliminar la tarea
                  },
                ); // Usa el helper
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_task',
        onPressed: () {
          _showTaskModal();
        },
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showTaskModal({int? index}) {
    final task = index != null ? tasks[index] : null; // Obtiene la tarea actual si existe
    final TextEditingController titleController = TextEditingController(
      text: task != null ? task.title : '', // Muestra el título de la tarea actual
    );
    final TextEditingController typeController = TextEditingController(
      text: task != null ? task.type : '', // Muestra el tipo de la tarea actual
    );
    final TextEditingController descriptionController = TextEditingController(
      text: task != null ? task.description : '', // Muestra la descripción de la tarea actual
    );
    final TextEditingController dateController = TextEditingController(
      text: task != null
          ? task.fechaToString()
          : '', // Muestra la fecha de la tarea actual
    );
    DateTime? dateSelected = task?.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index != null ? 'Editar Tarea' : 'Agregar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonWidgetsHelper.buildTextFieldController(titleController, 'Título'),
              CommonWidgetsHelper.buildSpacing(height: 16),
              CommonWidgetsHelper.buildTextFieldController(typeController, 'Tipo'),
              CommonWidgetsHelper.buildSpacing(height: 16),
              CommonWidgetsHelper.buildTextFieldController(descriptionController, 'Descripción'),
              CommonWidgetsHelper.buildSpacing(height: 16),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  hintText: 'Selecciona la fecha',
                ),
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: dateSelected ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (newDate != null) {
                    setState(() {
                      dateSelected = newDate;
                      dateController.text =
                          newDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CommonWidgetsHelper.buildButtonStyle('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  final newTask = Task(
                    title: titleController.text,
                    type: typeController.text.isNotEmpty
                        ? typeController.text
                        : taskTypeNormal,
                    description: descriptionController.text,
                    date: dateSelected ?? DateTime.now(),
                    deadLine: DateTime.now().add(const Duration(days: 1)), 
                    pasos: _taskService.getTaskWithSteps(titleController.text, DateTime.now().add(const Duration(days: 1))) // Obtiene los pasos de la tarea
                  );
                  if (index != null) {
                    _taskService.updateTask(index, newTask); // Actualiza la tarea existente
                  } else {
                    _taskService.createTask(newTask); // Crea una nueva tarea
                  }

                  setState(() {
                    tasks = _taskService.getTasks(); // Actualiza la lista de tareas
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos'),
                    ),
                  );
                }
              },
              child: CommonWidgetsHelper.buildButtonStyle('Guardar'),
            ),
          ],
        );
      },
    );
  }
}