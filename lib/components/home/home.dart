import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/dashboard_screen.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/shared/loading.dart';
import 'package:solid_app/components/login/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("There was an error"),
            );
          } else if (snapshot.hasData) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}
