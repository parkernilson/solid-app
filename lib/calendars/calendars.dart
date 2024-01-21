import 'package:flutter/material.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/services/auth.dart';
import 'package:solid_app/services/calendars.dart';
import 'package:solid_app/services/models/models.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/shared/loading.dart';

class CalendarsScreen extends StatelessWidget {
  const CalendarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserRecord>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendars'),
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
            child: FutureBuilder(
              future: CalendarService().getCalendars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("There was an error"),
                  );
                } else if (snapshot.hasData) {
                  final calendars = snapshot.data as List<CalendarRecord>;
                  final myCalendars = calendars
                      .where((element) => element.owner == user.id)
                      .toList();
                  final sharedWithMeCalendars = calendars
                      .where((element) => element.viewers.contains(user.id))
                      .toList();
                  return Column(children: [
                    const Text('My Calendars'),
                    Expanded(
                      child: ListView.builder(
                          itemCount: myCalendars.length,
                          itemBuilder: (context, index) {
                            final calendar = myCalendars[index];
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalendarScreen(
                                              calendar: calendar)));
                                },
                                child: ListTile(
                                  title: Text(calendar.title),
                                ));
                          }),
                    ),
                    const Text('Shared with me'),
                    Expanded(
                      child: ListView.builder(
                          itemCount: sharedWithMeCalendars.length,
                          itemBuilder: (context, index) {
                            final calendar = sharedWithMeCalendars[index];
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalendarScreen(
                                              calendar: calendar)));
                                },
                                child: ListTile(
                                  title: Text(calendar.title),
                                  subtitle: Text(calendar.id),
                                ));
                          }),
                    ),
                  ]);
                } else {
                  return const Center(
                    child: Text("There was an error"),
                  );
                }
              },
            )));
  }
}

class CalendarScreen extends StatelessWidget {
  final CalendarRecord calendar;

  const CalendarScreen({super.key, required this.calendar});

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
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      }
                    )
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero, 
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text('Options'),
                      ),
                      ListTile(title: const Text('Share'), onTap: () {
                        Navigator.pop(context);
                      })
                    ]
                  )
                ),
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
                          ));
                    }));
          } else {
            return const Center(
              child: Text("There was an error"),
            );
          }
        });
  }
}
