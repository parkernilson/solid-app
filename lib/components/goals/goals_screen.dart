import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/create_goal_modal.dart';
import 'package:solid_app/components/goals/dashboard.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/shared/loading.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user!;

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
                    final goals = snapshot.data!.goals;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('My Goals',
                                textScaler: TextScaler.linear(2)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return CreateGoalModal(user: user);
                                    });
                              },
                            )
                          ],
                        ),
                        ...goals.map(
                            (goalRecord) => GoalListItem(goal: goalRecord)),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text("There was an error"),
                    );
                  }
                })));
  }
}
