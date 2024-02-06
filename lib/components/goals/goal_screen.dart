import 'package:flutter/material.dart';
import 'package:solid_app/components/goals/create_entry_modal.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/shared/loading.dart';

class GoalScreen extends StatelessWidget {
  final GoalRecord goal;
  final UserRecord user;

  const GoalScreen({super.key, required this.goal, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GoalService().getGoalsStream(),
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: EntryService.instance.getEntriesStream(goalId: goal.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              print(snapshot.error?.toString());
              return const Center(child: Text("There was an error"));
            } else if (snapshot.hasData) {
              final entries = (snapshot.data as List<EntryRecord>)
                ..sort((a, b) => -DateTime.parse(a.created)
                    .compareTo(DateTime.parse(b.created)));
      
              final shareText = goal.owner == user.id
                  ? 'Shared with ${goal.shareRecord.viewers.length} people'
                  : 'Shared with you';
      
              return Scaffold(
                  appBar: AppBar(
                    title: Column(
                      children: [
                        Text(goal.title),
                        Text(shareText, style: const TextStyle(fontSize: 12))
                      ],
                    ),
                    // backwards navigation to the previous screen
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // open drawer button
                    actions: [
                      Builder(builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      })
                    ],
                  ),
                  drawer: Drawer(
                      child: ListView(padding: EdgeInsets.zero, children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Text('Options'),
                    ),
                    const ListTile(
                        title: const Text('Share'),
                        // onTap: () async {
                        //   try {
                        //     final result = await GoalService()
                        //         .sendShareRequest(
                        //             goalId: goal.id,
                        //             shareWithEmail:
                        //                 'parker.todd.nilson@gmail.com');
                        //     print('email send success: ${result.success}');
                        //   } catch (error) {
                        //     print(error);
                        //   }
                        //   if (context.mounted) Navigator.pop(context);
                        // }),
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Shared with'),
                    ),
                    ...goal.shareRecord.viewers.map((viewer) {
                      return ListTile(
                        title: Text(viewer),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await GoalService().unshareWithUser(
                                  goalId: goal.id, userId: viewer);
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      );
                    })
                  ])),
                  body: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen(entry: entry)));
                          },
                          child: ListTile(
                            title: Text(entry.textContent),
                            subtitle: Text(entry.dateFormatted),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  await EntryService.instance.deleteEntry(
                                      id: entry
                                          .id); // Delete the entry using EntryService
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CreateEntryModal(
                                user: user, goal: goal);
                          });
                    },
                    child: const Icon(Icons.add),
                  ));
            } else {
              return const Center(
                child: Text("There was an error"),
              );
            }
          });
      }
    );
  }
}
