import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solid_app/components/goals/create_goal_modal.dart';
import 'package:solid_app/components/goals/goal_screen.dart';
import 'package:solid_app/components/goals/goals_screen.dart';
import 'package:solid_app/models/models.dart';

class Dashboard extends StatelessWidget {
  final UserRecord user;
  final List<GoalRecord> goals;
  final List<SharedGoalRecord> sharedGoals;
  final List<SharedGoalRecord> acceptedSharedGoals;
  final List<SharedGoalRecord> unacceptedSharedGoals;

  Dashboard({
    super.key,
    required this.user,
    required this.goals,
    required this.sharedGoals,
  })  : acceptedSharedGoals =
            sharedGoals.where((goal) => goal.shareAccepted).toList(),
        unacceptedSharedGoals =
            sharedGoals.where((goal) => !goal.shareAccepted).toList();

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
              child: const Text('View all'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const GoalsScreen(),
                  ),
                );
              },
            )
          : const SizedBox(),
      const Row(children: [
        Text('Shared with me', textScaler: TextScaler.linear(2)),
      ]),
      unacceptedSharedGoals.isNotEmpty
          ? Container(
              color: Colors.red[100],
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(children: [
                Flexible(
                  child: Text(
                      'You have ${unacceptedSharedGoals.length} requests to share calendars with you',
                      textScaler: const TextScaler.linear(0.8)),
                ),
                TextButton(
                  child: const Text('View'),
                  onPressed: () {
                    // navigate to shared goals
                    print("navigate to share requests");
                  },
                )
              ]),
            )
          : const SizedBox(),
      ...acceptedSharedGoals
          .take(3)
          .map((goalRecord) => GoalListItem(goal: goalRecord, editable: false)),
      acceptedSharedGoals.length > 3
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => GoalScreen(goalId: goal.id),
            ),
          );
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
