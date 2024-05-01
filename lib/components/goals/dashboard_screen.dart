import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/dashboard.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/shared/loading.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user!;
    return StreamBuilder(
      stream: GoalService().getGoalPreviewsStream(userId: user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          return Dashboard(
            user: user,
            goalPreviews: snapshot.data!.goalsPreviews,
            sharedGoalPreviews: snapshot.data!.sharedGoalPreviews,
          );
        } else {
          return const Center(
            child: Text("There was an error"),
          );
        }
      },
    );
  }
}
