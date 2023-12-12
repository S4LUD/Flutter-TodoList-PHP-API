import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todolistapp/controllers/todo_controller.dart';

@RoutePage()
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  late TodoController todoController;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    todoController = TodoController(
        'https://c9ba-2001-4450-49c4-ca00-e481-8958-56b3-af5.ngrok-free.app/TodoListAPI/');
  }

  void registerUser() async {
    try {
      await todoController.signup(
          usernameController.text, passwordController.text);
      setState(() {
        successMessage =
            'User registered successfully, you can go back to logged in.';
      });
    } catch (e) {
      setState(() {
        successMessage = 'Failed to register user: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, // For password input
            ),
            if (successMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  successMessage,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
