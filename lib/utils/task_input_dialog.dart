import 'package:flutter/material.dart';

class TaskInputDialog extends StatefulWidget {
  const TaskInputDialog({super.key});

  @override
  TaskInputDialogState createState() => TaskInputDialogState();
}

class TaskInputDialogState extends State<TaskInputDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the dialog when tapping outside
        Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle task addition or any other logic here
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
