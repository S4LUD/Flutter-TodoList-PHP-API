import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todolistapp/models/todo_model.dart';

class TodoController {
  final String apiUrl;

  TodoController(this.apiUrl);

  Future<List<Todo>> fetchTodos(int userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl?userID=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['todos'];
      return responseData
          .map((todoData) => Todo(
                todoData['todoID'],
                todoData['title'],
                todoData['status'],
                todoData['userID'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(String title, int id) async {
    if (title.isEmpty) {
      return; // Do nothing if title is empty
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'userID': id,
      }),
    );

    if (response.statusCode == 200) {
      // Todo added successfully
    } else {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(int id, String newTitle) async {
    if (newTitle.isEmpty) {
      return; // Do nothing if title is empty
    }

    final response = await http.patch(
      Uri.parse(apiUrl), // Use the correct API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'todoID': id,
        'title': newTitle,
      }),
    );

    if (response.statusCode == 200) {
      // Todo updated successfully
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> updateTodoStatus(int id, bool currentStatus) async {
    final newStatus = currentStatus ? 1 : 0;

    final response = await http.put(
      Uri.parse(apiUrl), // Use the correct API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'todoID': id,
        'status': newStatus,
      }),
    );

    if (response.statusCode == 200) {
      // Todo status toggled successfully
    } else {
      throw Exception('Failed to toggle todo status');
    }
  }

  Future<void> deleteTodo(int todoID) async {
    final response = await http.delete(
      Uri.parse(apiUrl), // Use the correct API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'todoID': todoID,
      }),
    );

    if (response.statusCode == 200) {
      // Todo deleted successfully
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'login': true,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        // User authenticated successfully
        return {
          'logged_in': true,
          'user_id': responseData['user_id'],
          'username': responseData['username'],
        };
      } else {
        return {
          'message': responseData['message'],
        };
      }
    } else {
      return {
        'message': 'Failed to authenticate user',
      };
    }
  }

  Future<Map<String, dynamic>> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signup': true,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // User registered successfully
      if (responseData['status'] == 'success') {
        // User authenticated successfully
        return {
          'message': responseData['message'],
        };
      } else {
        return {
          'message': responseData['message'],
        };
      }
    } else {
      throw Exception('Failed to register user');
    }
  }
}
