import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/bloc/tarea/tarea_state.dart';
import 'package:vdenis/components/custom_bottom_navigation_bar.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/components/add_task_modal.dart';
import 'package:vdenis/views/tarea_detalle_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TareaBloc()..add(TareaLoadEvent()),
      child: const _TareaScreenContent(),
    );
  }
}

class _TareaScreenContent extends StatelessWidget {
  const _TareaScreenContent();
  
  static const int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TareaBloc, TareaState>(
          builder: (context, state) {
            int totalTareas = 0;
            if (state is TareaLoaded) {
              totalTareas = state.tareas.length;
            }
            return Text('${TareasConstantes.tituloAppBar} - Total: $totalTareas');
          },
        ),
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.grey[200],
      body: BlocConsumer<TareaBloc, TareaState>(
        listener: (context, state) {
          if (state is TareaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mensaje)),
            );
          } else if (state is TareaCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tarea creada con éxito')),
            );
          } else if (state is TareaUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tarea actualizada con éxito')),
            );
          } else if (state is TareaDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(TareasConstantes.tareaEliminada)),
            );
          }
        },
        builder: (context, state) {
          // Estado de carga inicial
          if (state is TareaInitial || 
              (state is TareaLoading)) {
            return const Center(child: CircularProgressIndicator());
          } 
            // Si hay tareas cargadas
          if (state is TareaLoaded) {
            // Lista de tareas
            final tareas = state.tareas;
            
            // Si no hay tareas
            if (tareas.isEmpty) {
              return const Center(
                child: Text(
                  TareasConstantes.listaVacia,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }
              return RefreshIndicator(
              onRefresh: () async {
                context.read<TareaBloc>().add(TareaLoadEvent());
                return Future.value();
              },
              child: ListView.builder(
                itemCount: tareas.length,
                itemBuilder: (context, index) {
                  
                  final tarea = tareas[index];
                  return GestureDetector(
                    onTap: () => _mostrarDetallesTarea(context, tareas, index),
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
                        if (tarea.id != null) {
                          context.read<TareaBloc>().add(
                            TareaDeleteEvent(tarea.id!),
                          );
                        }
                      },
                      child: construirTarjetaDeportiva(
                        tarea,
                        index,
                        () => _mostrarModalEditarTarea(context, tarea),
                      ),
                    ),
                  );
                },
              ),
            );
          }
            // Si hay un error
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ocurrió un error al cargar las tareas'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TareaBloc>().add(TareaLoadEvent()),
                  child: const Text('Intentar de nuevo'),
                ),
              ],
            ),
          );        
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(context),
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }
  
  // Método para mostrar detalles de tarea
  void _mostrarDetallesTarea(BuildContext context, List<Tarea> tareas, int indice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TareaDetalleScreen(
          tareas: tareas, 
          indice: indice,
        ),
      ),
    );
  }

  // Método para mostrar el modal de agregar tarea
  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        onTaskAdded: (Tarea nuevaTarea) {
          context.read<TareaBloc>().add(TareaCreateEvent(nuevaTarea));
        },
      ),
    );
  }

  // Método para mostrar el modal de editar tarea
  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (context) => AddTaskModal(
        taskToEdit: tarea,
        onTaskAdded: (Tarea tareaEditada) {
          if (tarea.id != null) {
            context.read<TareaBloc>().add(
              TareaUpdateEvent(
                taskId: tarea.id!,
                tarea: tareaEditada,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: La tarea no tiene un ID válido'),
              ),
            );
          }
        },
      ),
    );
  }}
