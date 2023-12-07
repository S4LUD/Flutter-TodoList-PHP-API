import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistapp/auth/app_router.gr.dart';
import 'package:todolistapp/models/todo_model.dart';
import 'todos_card.dart';

class ToDoPageBody extends StatelessWidget {
  final List<Todo> todos;
  final TextEditingController titleController;
  final Function(BuildContext) showAddInputModal;
  final Function(BuildContext, Map<String, dynamic>, int) showEditInputModal;
  final Function(int) deleteTodo;
  final Function(int, bool) updateTodoStatus;

  const ToDoPageBody({
    Key? key,
    required this.todos,
    required this.titleController,
    required this.showAddInputModal,
    required this.showEditInputModal,
    required this.deleteTodo,
    required this.updateTodoStatus,
  }) : super(key: key);

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ??
        ''; // Replace 'username' with your actual key
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBF4D4A),
      appBar: AppBar(
        // elevation: 0,
        title: const Text('ToDo App'),
      ),
      drawer: Drawer(
        child: FutureBuilder<String>(
          future: getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while fetching username
            } else if (snapshot.hasError) {
              return const Text(
                  'Error'); // Show error message if fetching fails
            } else {
              final username = snapshot.data ?? '';
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFFBF4D4A),
                    ),
                    child: Text(
                      'Welcome, $username',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // ignore: use_build_context_synchronously
                      AutoRouter.of(context).replace(const HomeRoute());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // ignore: use_build_context_synchronously
                      AutoRouter.of(context).replace(const HomeRoute());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // ignore: use_build_context_synchronously
                      AutoRouter.of(context).replace(const HomeRoute());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // ignore: use_build_context_synchronously
                      AutoRouter.of(context).replace(const HomeRoute());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      // ignore: use_build_context_synchronously
                      AutoRouter.of(context).replace(const HomeRoute());
                    },
                  ),
                  // Add more items as needed
                ],
              );
            }
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 86),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TodoCard(
                      id: todos[index].todoID,
                      taskName: todos[index].title,
                      taskCompleted: todos[index].status == 1,
                      onChanged: (status) {
                        updateTodoStatus(todos[index].todoID, status!);
                      },
                      onDelete: (id) {
                        deleteTodo(id);
                      },
                      onEdit: (id) {
                        Map<String, dynamic> todoData = {
                          'todoID': todos[index].todoID,
                          'title': todos[index].title,
                          'status': todos[index].status,
                        };
                        showEditInputModal(context, todoData, id);
                      },
                    ),
                    // Add your desired spacing between TodoCards,
                    // but not after the last one
                    if (index != todos.length - 1) const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddInputModal(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color(0xFFBF4D4A),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
