import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/dashboard.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/models/models.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/shared/loading.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserRecord>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Solid'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().logout();
              },
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder(
              stream: GoalService().getGoalListsStream(userId: user.id),
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
                    goals: snapshot.data!.goals,
                    sharedGoals: snapshot.data!.sharedGoals,
                  );
                } else {
                  return const Center(
                    child: Text("There was an error"),
                  );
                }
              },
            )));
  }
}
