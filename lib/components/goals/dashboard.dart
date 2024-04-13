import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solid_app/components/goals/create_goal_modal.dart';
import 'package:solid_app/models/models.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.user,
    required this.goals,
    required this.sharedGoals,
  });

  final UserRecord user;
  final List<GoalRecord> goals;
  final List<SharedGoalRecord> sharedGoals;

  @override
  Widget build(BuildContext context) {
    final items = [
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
                    return CreateGoalModal(user: user);
                  });
            },
          )
        ],
      ),
      ...goals.take(3).map((goalRecord) => GoalListItem(goal: goalRecord)),
      goals.length > 3
          ? TextButton(
              onPressed: () {
                // navigate to my goals
              },
              child: const Text('View all'),
            )
          : const SizedBox(),
      const Row(children: [
        Text('Shared with me', textScaler: TextScaler.linear(2)),
      ]),
      ...sharedGoals
          .take(3)
          .map((goalRecord) => GoalListItem(goal: goalRecord, editable: false)),
      sharedGoals.length > 3
          ? TextButton(
              onPressed: () {
                // navigate to shared goals
              },
              child: const Text('View all'),
            )
          : const SizedBox(),
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
  const GoalListItem({super.key, required this.goal, this.editable = true});

  final GoalRecord goal;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print('navigate to goal screen');
        },
        child: ListTile(
          title: Text(goal.title),
          trailing: editable
              ? IconButton(
                  icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                  onPressed: () async {
                    // show options
                  },
                )
              : null,
        ));
  }
}
