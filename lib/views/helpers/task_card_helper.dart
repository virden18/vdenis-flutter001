import 'package:flutter/material.dart';
import 'package:vdenis/domain/task.dart';
import 'package:vdenis/constants/constants.dart';

Widget buildTaskCard(Task task, BuildContext context, int index, {required void Function(int) onEdit}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: ListTile(
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Tipo: ${task.type}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 7),
              Text(
                task.date.toLocal().toString().split(' ')[0],
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          task.type == TASK_TYPE_URGENT
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

          IconButton(
            onPressed: () {
              onEdit(index);
            }, 
            icon: const Icon(Icons.edit),
            color: Colors.black,
          ),        
        ],
      ),
    ),
  );
}