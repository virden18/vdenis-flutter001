import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/bloc/tarea/tarea_bloc.dart';
import 'package:vdenis/bloc/tarea/tarea_event.dart';
import 'package:vdenis/bloc/tarea/tarea_state.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:vdenis/bloc/tarea_contador/tarea_contador_state.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/domain/tarea.dart';
import 'package:vdenis/helpers/progreso_card_helper.dart';
import 'package:vdenis/helpers/snackbar_helper.dart';
import 'package:vdenis/helpers/task_card_helper.dart';
import 'package:vdenis/components/add_task_modal.dart';
import 'package:vdenis/views/tarea_detalle_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value:
              context.read<TareaBloc>()
                ..add(TareaLoadEvent(forzarRecarga: false)),
        ),
        BlocProvider(create: (_) => TareaContadorBloc()),
      ],
      child: const _TareaScreenContent(),
    );
  }
}

class _TareaScreenContent extends StatelessWidget {
  const _TareaScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Volver',
        ),
        title: BlocBuilder<TareaContadorBloc, TareaContadorState>(
          builder: (context, contadorState) {
            return const Text(TareasConstantes.tituloAppBar);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refrescar datos',
            onPressed: () {
              context.read<TareaBloc>().add(
                TareaLoadEvent(forzarRecarga: true),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(TareasConstantes.datosActualizados),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: MultiBlocListener(
        listeners: [
          BlocListener<TareaBloc, TareaState>(
            listener: (context, state) {
              if (state is TareaError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.mensaje)));
              } else if (state is TareaCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarea creada con éxito')),
                );
                context.read<TareaContadorBloc>().add(
                  SetTotalTareas(state.tareas.length),
                );
              } else if (state is TareaDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(TareasConstantes.tareaEliminada),
                  ),
                );
                context.read<TareaContadorBloc>().add(
                  SetTotalTareas(state.tareas.length),
                );
              } else if (state is TareaLoaded) {
                int totalTareas = state.tareas.length;
                int tareasCompletadas =
                    state.tareas.where((t) => t.completada).length;
                context.read<TareaContadorBloc>().add(
                  SetTotalTareas(totalTareas),
                );
                context.read<TareaContadorBloc>().add(
                  SetTareasCompletadas(tareasCompletadas),
                );
              }
            },
          ),
          BlocListener<TareaBloc, TareaState>(
            listenWhen: (previous, current) => current is TareaCompletada,
            listener: (context, state) {
              if (state is TareaCompletada) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.completada
                          ? 'Tarea marcada como completada'
                          : 'Tarea desmarcada',
                    ),
                    backgroundColor:
                        state.completada ? Colors.green : Colors.orange,
                    duration: const Duration(seconds: 2),
                  ),
                );

                int totalTareas = state.tareas.length;
                int tareasCompletadas =
                    state.tareas.where((t) => t.completada).length;

                context.read<TareaContadorBloc>().add(
                  SetTotalTareas(totalTareas),
                );
                context.read<TareaContadorBloc>().add(
                  SetTareasCompletadas(tareasCompletadas),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<TareaBloc, TareaState>(
          builder: (context, state) {
            if (state is TareaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TareaLoaded) {
              final tareas = state.tareas;
              final ultimaActualizacionWidget =
                  state.ultimaActualizacion != null
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${TareasConstantes.ultimaActualizacion} ${DateFormat(AppConstantes.formatoFecha).format(state.ultimaActualizacion!)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : const SizedBox.shrink();

              if (tareas.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ultimaActualizacionWidget,
                    const Center(
                      child: Text(
                        TareasConstantes.listaVacia,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  ultimaActualizacionWidget,
                  BlocBuilder<TareaContadorBloc, TareaContadorState>(
                    builder: (context, contadorState) {
                      return ProgresoCardHelper(contadorState: contadorState);
                    },
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<TareaBloc>().add(
                          TareaLoadEvent(forzarRecarga: true),
                        );
                        return Future.value();
                      },
                      child: ListView.builder(
                        itemCount: tareas.length,
                        itemBuilder: (context, index) {
                          final tarea = tareas[index];
                          return GestureDetector(
                            onTap:
                                () => _mostrarDetallesTarea(
                                  context,
                                  tareas,
                                  index,
                                ),
                            child: Dismissible(
                              key: Key(tarea.id ?? tarea.titulo),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                if (tarea.id != null) {
                                  context.read<TareaBloc>().add(
                                    TareaDeleteEvent(tarea.id!),
                                  );
                                }
                              },
                              child: construirTarjetaDeportiva(
                                context,
                                tarea,
                                index,
                                () => _mostrarModalEditarTarea(context, tarea),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ocurrió un error al cargar las tareas'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<TareaBloc>().add(TareaLoadEvent()),
                    child: const Text('Intentar de nuevo'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final state = context.read<TareaBloc>().state;
          if (state is TareaLoaded && state.tareas.length >= 3) {
            SnackBarHelper.mostrarAdvertencia(
              context,
              mensaje: 'No puedes crear más de 3 tareas',
            );
          } else {
            _mostrarModalAgregarTarea(context);
          }
        },
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDetallesTarea(
    BuildContext context,
    List<Tarea> tareas,
    int indice,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TareaDetalleScreen(tareas: tareas, indice: indice),
      ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AddTaskModal(
            onTaskAdded: (Tarea nuevaTarea) {
              context.read<TareaBloc>().add(TareaCreateEvent(nuevaTarea));
            },
          ),
    );
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder:
          (context) => AddTaskModal(
            taskToEdit: tarea,
            onTaskAdded: (Tarea tareaEditada) {
              if (tarea.id != null) {
                context.read<TareaBloc>().add(
                  TareaUpdateEvent(taskId: tarea.id!, tarea: tareaEditada),
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
  }
}
