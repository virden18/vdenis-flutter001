import 'package:flutter/material.dart';
import 'package:vdenis/data/tarea_repository.dart';
import 'package:vdenis/components/custom_bottom_navigation_bar.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/views/task_details_screen.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/components/add_task_modal.dart'; // Importa el modal reutilizable

class TareaScreen extends StatefulWidget {
  const TareaScreen({super.key});

  @override
  TareaScreenState createState() => TareaScreenState();
}

class TareaScreenState extends State<TareaScreen> {
  final TareasRepository _tareasRepository = TareasRepository();
  final ScrollController _scrollController = ScrollController();
  bool _cargando = false;
  final int _limitePorPagina = 5;
  final int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  List<Task> _tareas = []; // Lista persistente de tareas

  @override
  void initState() {
    super.initState();
    _cargarTareasIniciales(); // Carga inicial de tareas
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Método para recargar las tareas (pull-to-refresh)
  Future<void> _recargarTareas() async {
    
    // Recarga las tareas
    await _cargarTareasIniciales();
    
    return Future.value();
  }

  Future<void> _cargarTareasIniciales() async {
    setState(() {
      _cargando = true;
    });

    try {
      final tareas = await _tareasRepository.obtenerTareas(
        limite: _limitePorPagina,
      );

      setState(() {
        _tareas = tareas;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar tareas: $e')),
      );
    }
  }

  void _mostrarModalAgregarTarea() {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        onTaskAdded: (Task nuevaTarea) async {
          try {
            Task tareaActualizada = await _tareasRepository.agregarTarea(nuevaTarea);
            setState(() {
              _tareas.insert(0, tareaActualizada); // Agrega la nueva tarea al inicio de la lista
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al agregar tarea: $e')),
            );
          }
        },
      ),
    );
  }

  Future<void> _eliminarTarea(int index) async {
    final String? taskId = _tareas[index].id;
    if (taskId != null) {
      try {
        await _tareasRepository.eliminarTarea(taskId);
        setState(() {
          _tareas.removeAt(index); // Elimina la tarea de la lista persistente
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar tarea: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: La tarea no tiene un ID válido')),
      );
    }
  }

  void _mostrarDetallesTarea(int indice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          tareas: _tareas, 
          indice: indice
        ),
      ),
    );
  }

  void _mostrarModalEditarTarea(Task tarea, int index) {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        taskToEdit: tarea,
        onTaskAdded: (Task tareaEditada) async {
          if (tarea.id != null) {
            try {
              Task tareaActualizada = await _tareasRepository.actualizarTarea(tarea.id!, tareaEditada);
              setState(() {
                _tareas[index] = tareaActualizada; // Actualiza la tarea en la lista persistente
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al actualizar tarea: $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: La tarea no tiene un ID válido')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${TareasConstantes.tituloAppBar} - Total: ${_tareas.length}')
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.grey[200],
      body: _tareas.isEmpty && !_cargando
        ? const Center(
            child: Text(
              TareasConstantes.listaVacia,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
        : RefreshIndicator(
            onRefresh: _recargarTareas,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _tareas.length + (_cargando ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _tareas.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final tarea = _tareas[index];
                return GestureDetector(
                  onTap: () => _mostrarDetallesTarea(index),
                  child: Dismissible(
                    key: Key(tarea.id ?? tarea.titulo),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _eliminarTarea(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(TareasConstantes.tareaEliminada)),
                      );                
                    },
                    child: construirTarjetaDeportiva(
                      tarea, 
                      index,
                      () => _mostrarModalEditarTarea(tarea, index),
                    ),
                  ),
                );
              },
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarModalAgregarTarea,
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}
