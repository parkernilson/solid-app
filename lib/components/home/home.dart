import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/components/goals/dashboard_screen.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/shared/loading.dart';
import 'package:solid_app/components/login/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(child: Text("There was an error"),);
        } else if (snapshot.hasData) {
          return Provider<UserRecord>(
            create: (context) => snapshot.data!,
            child: const DashboardScreen(),
          );
        } else {
          return const LoginScreen();
        }
      }
    );
  }
}