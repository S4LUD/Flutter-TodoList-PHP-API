import 'package:flutter/material.dart';
import 'package:todolistapp/utils/round_checkbox.dart';

class TodoCard extends StatelessWidget {
  final int id;
  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(int) onDelete;
  final Function(int) onEdit;

  const TodoCard({
    Key? key,
    required this.id,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            RoundedCheckbox(
              value: taskCompleted,
              onChanged: onChanged,
              activeColor: const Color(0xFFBF4D4A),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: TextStyle(
                      fontSize: 16.0,
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3CA2FA),
                borderRadius: BorderRadius.circular(5),
              ),
              width: 30,
              height: 30,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(id),
                color: Colors.white,
                iconSize: 15,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFBF4D4A),
                borderRadius: BorderRadius.circular(5),
              ),
              width: 30,
              height: 30,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Task'),
                        content: const Text(
                            'Are you sure you want to delete this task?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Call the delete function and then close the dialog
                              onDelete(id); // Assuming todoID is accessible
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                color: Colors.white,
                iconSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
