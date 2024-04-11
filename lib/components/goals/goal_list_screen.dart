import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  return MainGoalList(user: user, goals: snapshot.data!);
                } else {
                  return const Center(
                    child: Text("There was an error"),
                  );
                }
              },
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CreateGoalModal(user: user);
                });
          },
          child: const Icon(Icons.add),
        ));
  }
}

class MainGoalList extends StatelessWidget {
  const MainGoalList({
    super.key,
    required this.user,
    required this.goals,
  });

  final UserRecord user;
  final List<GoalRecord> goals;

  @override
  Widget build(BuildContext context) {
    final myGoals = goals.where((element) => element.owner == user.id).toList();
    final sharedWithMeGoals = goals
        .where((element) => element.shareRecord.viewers.contains(user.id))
        .toList();

    final items = [
      Row(children: [
        const Text('My Goals', textScaler: TextScaler.linear(2)),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            print('add a goal');
          },
        )
      ]),
      ...myGoals.map((goalRecord) => GoalListItem(goal: goalRecord)),
      const Row(children: [
        Text('Shared with me', textScaler: TextScaler.linear(2)),
      ]),
      ...sharedWithMeGoals.map((goalRecord) => GoalListItem(goal: goalRecord)),
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final widget = items[index];
        return widget;
      },
    );
  }
}

class GoalListItem extends StatelessWidget {
  const GoalListItem({super.key, required this.goal});

  final GoalRecord goal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print('navigate to goal screen');
        },
        child: ListTile(
          title: Text(goal.title),
          trailing: IconButton(
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () async {
              // show options
            },
          ),
        ));
  }
}
