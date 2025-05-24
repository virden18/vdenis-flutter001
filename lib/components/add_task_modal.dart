import 'package:flutter/material.dart';
import 'package:vdenis/domain/tarea.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Tarea) onTaskAdded;
  final Tarea? taskToEdit; // Tarea opcional para editar

  const AddTaskModal({super.key, required this.onTaskAdded, this.taskToEdit});

  @override
  AddTaskModalState createState() => AddTaskModalState();
}

class AddTaskModalState extends State<AddTaskModal> {
  late TextEditingController tituloController;
  late TextEditingController descripcionController;
  late TextEditingController fechaController;
  late TextEditingController fechaLimiteController;
  DateTime? fechaSeleccionada;
  DateTime? fechaLimiteSeleccionada;
  late String tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos de la tarea a editar (si existe)
    tituloController = TextEditingController(
      text: widget.taskToEdit?.titulo ?? '',
    );
    descripcionController = TextEditingController(
      text: widget.taskToEdit?.descripcion ?? '',
    );
    fechaSeleccionada = widget.taskToEdit?.fecha;
    fechaController = TextEditingController(
      text:
          fechaSeleccionada != null
              ? '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'
              : '',
    );

    fechaLimiteSeleccionada = widget.taskToEdit?.fechaLimite;
    fechaLimiteController = TextEditingController(
      text:
          fechaLimiteSeleccionada != null
              ? '${fechaLimiteSeleccionada!.day}/${fechaLimiteSeleccionada!.month}/${fechaLimiteSeleccionada!.year}'
              : '',
    );

    // Inicializa el tipo de tarea
    tipoSeleccionado = widget.taskToEdit?.tipo ?? 'normal';
  }

  void _guardarTarea() {
    final tarea = Tarea(
      titulo: tituloController.text,
      descripcion: descripcionController.text,
      tipo: tipoSeleccionado,
      fecha: fechaSeleccionada,
      fechaLimite: fechaLimiteSeleccionada,
    );
    widget.onTaskAdded(tarea);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taskToEdit == null ? 'Agregar Tarea' : 'Editar Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
                hintText: 'Seleccionar Fecha',
              ),
              onTap: () async {
                DateTime? nuevaFecha = await showDatePicker(
                  context: context,
                  initialDate: fechaSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (nuevaFecha != null) {
                  setState(() {
                    fechaSeleccionada = nuevaFecha;
                    fechaController.text =
                        '${nuevaFecha.day}/${nuevaFecha.month}/${nuevaFecha.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaLimiteController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha Límite',
                border: OutlineInputBorder(),
                hintText: 'Seleccionar Fecha Límite',
              ),
              onTap: () async {
                DateTime? nuevaFechaLimite = await showDatePicker(
                  context: context,
                  initialDate: fechaLimiteSeleccionada ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (nuevaFechaLimite != null) {
                  setState(() {
                    fechaLimiteSeleccionada = nuevaFechaLimite;
                    fechaLimiteController.text =
                        '${nuevaFechaLimite.day}/${nuevaFechaLimite.month}/${nuevaFechaLimite.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de Tarea',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'normal', child: Text('Normal')),
                DropdownMenuItem(value: 'urgente', child: Text('Urgente')),
              ],
              onChanged: (String? nuevoValor) {
                setState(() {
                  tipoSeleccionado = nuevoValor!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (tituloController.text.isEmpty ||
                descripcionController.text.isEmpty ||
                fechaSeleccionada == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, completa todos los campos'),
                ),
              );
              return;
            }
            _guardarTarea();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
