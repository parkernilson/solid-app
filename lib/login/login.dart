import 'package:flutter/material.dart';
import 'package:solid_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password'
              ),
            ),
            // button to perform login
            ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService().login(emailController.text, passwordController.text);
                } catch(e) {
                  print(e);
                }
              },
              child: const Text('Login')
            ),
          ]
        )
      )
    );
  }
}