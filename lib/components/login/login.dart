import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solid_app/services/auth.dart';

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
        body: Stack(children: [
      Container(
        color: Theme.of(context).colorScheme.primary,
      ),
      Positioned(
        bottom: -10,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 0,
          child: OverflowBox(
            alignment: Alignment.bottomCenter,
            maxWidth: MediaQuery.of(context).size.width * 2,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/images/mountains.png',
              width: MediaQuery.of(context).size.width * 2,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top, left: 32, right: 32),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.only(top: 64, bottom: 48),
              child: Image.asset(
                'assets/images/solid_logo.png',
              ),
            ),
            Column(
              children: [
                TextField(
                  controller: emailController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 32),
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final devEmail = dotenv.get('DEV_SOLID_EMAIL');
                      final devPassword = dotenv.get('DEV_SOLID_PASSWORD');
                      if (devEmail.isNotEmpty &&
                          devPassword.isNotEmpty &&
                          (emailController.text.isEmpty ||
                              passwordController.text.isEmpty)) {
                        await AuthService().login(devEmail, devPassword);
                      } else {
                        await AuthService().login(
                            emailController.text, passwordController.text);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Login')),
            ),
          ])),
    ]));
  }
}
