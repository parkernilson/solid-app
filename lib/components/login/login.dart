import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solid_app/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  dispose() {
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
                  const Column(
                    children: [
                      Center(
                        child: FaIcon(
                          FontAwesomeIcons.handshakeAngle,
                          size: 150,
                        ),
                      ),
                      Center(
                          child: Text('SOLID',
                              style: TextStyle(
                                  fontFamily: 'OpenSans', fontSize: 42))),
                    ],
                  ),
                  Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                    ],
                  ),
                  // button to perform login
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          final email = dotenv.get('DEV_SOLID_EMAIL',
                              fallback: emailController.text);
                          final password = dotenv.get('DEV_SOLID_PASSWORD',
                              fallback: passwordController.text);
                          await AuthService().login(email, password);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text('Login')),
                ])));
  }
}
