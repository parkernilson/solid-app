import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/components/goals/create_goal_modal.dart';
import 'package:solid_app/components/goals/dashboard.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/services/auth.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key, required this.goals});

  final List<GoalRecord> goals;

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user;

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Goals', textScaler: TextScaler.linear(2)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const Text("temp");
                              // return CreateGoalModal(user: user);
                            });
                      },
                    )
                  ],
                ),
                ...goals.map((goalRecord) => GoalListItem(goal: goalRecord)),
              ],
            )));
  }
}
