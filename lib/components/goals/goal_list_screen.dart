import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/goal_screen.dart';
import 'package:solid_app/components/goals/create_goal_modal.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/models/models.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/shared/loading.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserRecord>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Goals'),
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
              stream: GoalService().getGoalsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("There was an error"),
                  );
                } else if (snapshot.hasData) {
                  final goals = snapshot.data as List<GoalRecord>;
                  final myGoals = goals
                      .where((element) => element.owner == user.id)
                      .toList();
                  final sharedWithMeGoals = goals
                      .where((element) => element.shareRecord.viewers.contains(user.id))
                      .toList();
                  final items = [
                    'My Goals',
                    ...myGoals,
                    'Shared with me',
                    ...sharedWithMeGoals
                  ];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item is String) {
                        return ListTile(
                          title: Text(item, textScaler: const TextScaler.linear(2)),
                        );
                      } else if (item is GoalRecord) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoalScreen(goal: item, user: user)));
                            },
                            child: ListTile(
                              title: Text(item.title),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await GoalService()
                                        .deleteGoal(id: item.id);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ));
                      } else {
                        return const Center(
                          child: Text("There was an error"),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text("There was an error"),
                  );
                }
              },
            )
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CreateGoalModal(user: user);
                });
          },
          child: const Icon(Icons.add),
        )
    );
  }
}
