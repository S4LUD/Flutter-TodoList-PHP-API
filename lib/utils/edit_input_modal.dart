import 'package:flutter/material.dart';

class ToDoEditInput extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) editToDoList;
  final Map<String, dynamic> taskData;
  final int index;
  final FocusNode _focusNode = FocusNode();

  ToDoEditInput({
    Key? key,
    required this.textController,
    required this.editToDoList,
    required this.taskData,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textController.text = taskData['title'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        height: 105,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: textController,
                    focusNode:
                        _focusNode, // Assign the focus node to the TextField
                    decoration: const InputDecoration(
                      hintText: 'Update a task',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      textController.clear();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      "CANCEL",
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        // Pass updated task parameters
                        editToDoList(
                          textController.text,
                        );
                        textController.clear();
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    child: const Text(
                      "UPDATE",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
