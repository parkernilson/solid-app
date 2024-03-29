import 'package:flutter/material.dart';
import 'package:solid_app/calendars/create_entry_modal.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/services/models/models.dart';
import 'package:solid_app/shared/loading.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarRecord calendar;
  final UserRecord user;

  const CalendarScreen({super.key, required this.calendar, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EntryService.instance.getEntriesStream(calendarId: calendar.id),
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
            return Scaffold(
                appBar: AppBar(
                  title: Text(calendar.title),
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
                  ListTile(
                      title: const Text('Share'),
                      onTap: () {
                        Navigator.pop(context);
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
                                await EntryService.instance.deleteEntry(id: entry.id); // Delete the entry using EntryService
                              } catch(e) {
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
                          return CreateEntryModal(user: user, calendar: calendar);
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
}