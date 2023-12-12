import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolistapp/auth/app_router.gr.dart';
import 'package:todolistapp/controllers/todo_controller.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  final Function(bool?) onResult;

  const LoginScreen({Key? key, required this.onResult}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late TodoController todoController;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    todoController = TodoController(
        'https://c9ba-2001-4450-49c4-ca00-e481-8958-56b3-af5.ngrok-free.app/TodoListAPI/');
  }

  Future<void> authenticateUser() async {
    try {
      final response = await todoController.login(
          usernameController.text, passwordController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response['logged_in']) {
        prefs.setBool('logged_in', true);
        prefs.setInt('userId', response['user_id']);
        prefs.setString('username', response['username']);
        widget.onResult.call(true);
      } else {
        // Set the error message for failed authentication
        setState(() {
          errorMessage =
              'Authentication failed. Please check your credentials.';
        });
      }
    } catch (e) {
      // Set the error message for general failure
      setState(() {
        errorMessage = 'Failed to authenticate user. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: authenticateUser,
                  child: const Text('Login'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const SignupRoute());
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
