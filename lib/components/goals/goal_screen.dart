import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/create_entry_modal.dart';
import 'package:solid_app/components/goals/share_goal_modal.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/shared/loading.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user!;
    return FutureBuilder(
        future: GoalService().getGoal(id: goalId),
        builder: (goalContext, goalSnapshot) {
          if (goalSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (goalSnapshot.hasError) {
            return Center(
              child: Text(goalSnapshot.error.toString()),
            );
          } else if (goalSnapshot.hasData) {
            final goal = goalSnapshot.data!;
            return StreamBuilder(
              stream: EntryService().getEntriesStream(goalId: goalId),
              builder: (entriesContext, entrySnapshot) {
                if (entrySnapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (entrySnapshot.hasError) {
                  return Center(
                    child: Text(entrySnapshot.error.toString()),
                  );
                } else if (entrySnapshot.hasData) {
                  final entries = entrySnapshot.data!;
                  return GoalPage(user: user, goal: goal, entries: entries);
                } else {
                  return const Center(
                    child: Text('No entry found'),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text('No goal found'),
            );
          }
        });
  }
}

class GoalPage extends StatelessWidget {
  const GoalPage(
      {super.key,
      required this.user,
      required this.goal,
      required this.entries});

  final UserRecord user;
  final GoalRecord goal;
  final List<EntryRecord> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(goal.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'share') {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ShareGoalModal(user: user, goal: goal);
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'share',
                  child: Text('Share'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Entries', textScaler: TextScaler.linear(2)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return CreateEntryModal(goal: goal, user: user);
                        });
                  },
                )
              ],
            ),
            ...(entries..sort((a, b) => a.createdDate.compareTo(b.createdDate)))
                .map((entry) => EntryListItem(entry: entry))
          ],
        ));
  }
}

class EntryListItem extends StatelessWidget {
  const EntryListItem({super.key, required this.entry});

  final EntryRecord entry;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Entry: ${entry.textContent}'),
      Text('Created at: ${entry.dateFormatted}'),
    ],);
  }
}