import 'package:flutter/material.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/shared/loading.dart';

class ShareRequestsScreen extends StatelessWidget {
  const ShareRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GoalService().getGoalListsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          final sharedGoals = snapshot.data!.sharedGoals;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Share Requests'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    AuthService().logout();
                  },
                )
              ],
            ),
            body: Column(
              children: [
                const Text('Share Requests'),
                ...sharedGoals
                    .where((goal) => !goal.shareAccepted)
                    .map((goal) => ListTile(
                          title: Text(goal.title),
                          subtitle: Text(goal.owner),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  GoalService().acceptShareRequest(goalId: goal.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  GoalService().rejectShareRequest(goalId: goal.id);
                                },
                              ),
                            ],
                          ),
                        ))
              ]
            )
          );
        } else {
          return const Center(
            child: Text("There was an error"),
          );
        }
      }
    );
  }
}