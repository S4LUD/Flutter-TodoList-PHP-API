import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistapp/controllers/todo_controller.dart';
import 'package:todolistapp/models/todo_model.dart';
import 'package:todolistapp/utils/add_input_modal.dart';
import 'package:todolistapp/utils/edit_input_modal.dart';
import 'package:todolistapp/utils/todo_page_body.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  ToDoPageState createState() => ToDoPageState();
}

class ToDoPageState extends State<HomeScreen> {
  List<Todo> todos = [];
  TextEditingController titleController = TextEditingController();
  late TodoController todoController;
  late SharedPreferences prefs;
  int? userId;

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((_) {
      checkUserLogin();
      todoController = TodoController('http://192.168.1.80/TodoListAPI/');
      fetchTodos();
    });
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> checkUserLogin() async {
    if (prefs.containsKey('userId')) {
      setState(() {
        userId = prefs.getInt('userId');
      });
    }
  }

  Future<void> fetchTodos() async {
    if (userId != null) {
      final fetchedTodos = await todoController.fetchTodos(userId!);
      setState(() {
        todos = fetchedTodos;
      });
    }
  }

  Future<void> addTodo() async {
    if (userId != null) {
      await todoController.addTodo(titleController.text, userId!);
      titleController.clear();
      fetchTodos();
    } else {
      // Handle the case where userId is null, maybe show an error message
      // print('User not logged in');
    }
  }

  Future<void> updateTodo(int todoID) async {
    await todoController.updateTodo(todoID, titleController.text);
    titleController.clear();
    fetchTodos();
  }

  void _deleteTodo(int todoID) async {
    await todoController.deleteTodo(todoID);
    fetchTodos();
  }

  void _updateTodoStatus(int todoID, bool status) async {
    await todoController.updateTodoStatus(todoID, status);
    fetchTodos();
  }

  void _showAddInputModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ToDoAddInput(
          textController: titleController,
          addToDoList: (taskData) {
            addTodo();
          },
        );
      },
    );
  }

  void _showEditInputModal(
      BuildContext context, Map<String, dynamic> taskData, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ToDoEditInput(
          textController: titleController,
          editToDoList: (taskData) {
            updateTodo(index);
          },
          taskData: taskData,
          index: index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToDoPageBody(
      todos: todos,
      titleController: titleController,
      showAddInputModal: _showAddInputModal,
      showEditInputModal: _showEditInputModal,
      deleteTodo: _deleteTodo,
      updateTodoStatus: _updateTodoStatus,
    );
  }
}
